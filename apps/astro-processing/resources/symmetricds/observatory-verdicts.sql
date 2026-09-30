delimiter $;
-- astro-stacker's verdicts on subs, applied to the observatory's Target
-- Scheduler (TS) database. SQLite, run on the observatory by SymmetricDS as
-- an SQL event, so nobody edits the live file by hand:
--
--   symadmin --engine home send-sql --node observatory \
--     --file /opt/symmetric-ds/bootstrap/observatory-verdicts.sql stacker_verdict
--
-- It is idempotent: every object is dropped (triggers, views) or created
-- only if missing (tables), so it can be sent again after an edit.
-- Statements end in $, set by the first line, because trigger bodies hold
-- semicolons. SymmetricDS's script reader takes a "delimiter" statement only
-- when it ends in the current delimiter, hence the semicolon there, and it
-- fails on a delimiter longer than one character (3.16.7 reads past the end
-- of each line), hence not $$. Note --file: symadmin's -f is --force.
--
-- How it works. astro-stacker writes a row into stacker_verdict in home's
-- schedulerdb for each sub it leaves out of its masters (low_score, moon), and
-- SymmetricDS copies the row here. The trigger below then demotes the
-- acquired image to Rejected and takes one off its exposure plan's accepted
-- count, so TS goes on imaging the target. It acts only on a plan TS is not
-- grading: TS's grader reads the plan, grades, then writes accepted + 1 from
-- what it read, which would undo a decrement made in between. TS grades a
-- plan only right after saving one of its images (or when told to in its UI),
-- so a plan is left alone while it has an image from the last 30 minutes, or
-- a Pending one from the last 12 hours. A verdict that could not be applied
-- is sent again by the stacker (attempt + 1, which fires the UPDATE trigger).
--
-- Decrements can still be lost: saving a target in TS's editor writes back
-- the accepted counts it loaded. stacker_plan_ledger records, for every plan a
-- verdict touched, how far accepted stood from the number of Accepted images
-- (TS's own counts already differ for a quarter of the plans: purges, edits,
-- imports). When accepted later drifts above that, with none of the plan's
-- images deleted, the difference is taken back off, but never more than the
-- decrements the verdicts made, and the plan is settled where it then stands:
-- any other change is taken as intended. The cost: raising accepted by hand
-- on such a plan is undone, up to the number of stacker rejections in it.
--
-- The trigger's own writes to acquiredimage and exposureplan are captured
-- and pushed back to home because those two sym_triggers have
-- sync_on_incoming_batch = 1 and their trigger_routers ping_back_enabled = 1
-- (home-config.sql); otherwise SymmetricDS ignores changes made while it
-- loads a batch.


CREATE TABLE IF NOT EXISTS stacker_verdict (
    acquiredimage_id INTEGER NOT NULL PRIMARY KEY,
    guid VARCHAR NOT NULL,
    exposureplan_id INTEGER NOT NULL,
    -- 2: reject; 1: undo an earlier reject by the stacker.
    verdict INTEGER NOT NULL,
    reason VARCHAR NOT NULL,
    attempt INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
)$

-- A row here asks for its plan to be reconciled (see above).
CREATE TABLE IF NOT EXISTS stacker_reconcile (
    exposureplan_id INTEGER NOT NULL PRIMARY KEY,
    attempt INTEGER NOT NULL DEFAULT 0,
    updated_at TIMESTAMP
)$

-- Local only: not replicated.
CREATE TABLE IF NOT EXISTS stacker_plan_ledger (
    exposureplan_id INTEGER NOT NULL PRIMARY KEY,
    -- accepted less the plan's Accepted images, when last settled.
    accepted_offset INTEGER NOT NULL,
    -- The plan's images then, and the highest Id among them: fewer images
    -- up to max_id later means some were deleted.
    images INTEGER NOT NULL,
    max_id INTEGER NOT NULL,
    -- Decrements the verdicts made, net of undos: the most one reconcile
    -- takes off. Not used up by reconciling, since a correction can be
    -- overwritten the same way. corrected counts corrections, for the record.
    applied INTEGER NOT NULL DEFAULT 0,
    corrected INTEGER NOT NULL DEFAULT 0,
    -- Scratch for one reconcile.
    fix INTEGER NOT NULL DEFAULT 0,
    -- Bumped to reconcile (stacker_plan_reconcile).
    reconciles INTEGER NOT NULL DEFAULT 0,
    updated_at INTEGER
)$

-- The one change to a TS table. acquiredimage has no index on its plan, and
-- exposureId sits after the metadata blob, so every count by plan read all
-- 700 MB: 42 ms a verdict, 2 s for a batch of 50, all of it holding the
-- write lock TS waits at most 5 s for. With the index a verdict takes 0.4 ms.
-- TS neither names nor checks indexes, and its own queries by plan gain.
CREATE INDEX IF NOT EXISTS stacker_acquiredimage_plan ON acquiredimage (exposureId, gradingStatus, acquireddate)$

-- Plans TS is not grading: no image in the last 30 minutes (acquireddate is
-- the exposure start, in Unix seconds) and no Pending one in the last 12
-- hours.
DROP VIEW IF EXISTS stacker_plan_quiet$
CREATE VIEW stacker_plan_quiet AS
SELECT e.Id AS exposureplan_id
FROM exposureplan e
WHERE NOT EXISTS (SELECT 1 FROM acquiredimage a WHERE a.exposureId = e.Id
                  AND a.acquireddate > CAST(strftime('%s', 'now') AS INTEGER) - 1800)
  AND NOT EXISTS (SELECT 1 FROM acquiredimage a WHERE a.exposureId = e.Id AND a.gradingStatus = 0
                  AND a.acquireddate > CAST(strftime('%s', 'now') AS INTEGER) - 43200)$

DROP VIEW IF EXISTS stacker_plan_state$
CREATE VIEW stacker_plan_state AS
SELECT e.Id AS exposureplan_id,
       coalesce(e.accepted, 0) AS accepted,
       (SELECT count(*) FROM acquiredimage a WHERE a.exposureId = e.Id AND a.gradingStatus = 1) AS accepted_images,
       (SELECT count(*) FROM acquiredimage a WHERE a.exposureId = e.Id) AS images,
       (SELECT coalesce(max(a.Id), 0) FROM acquiredimage a WHERE a.exposureId = e.Id) AS max_id
FROM exposureplan e$

-- Reconcile a quiet plan: put back decrements lost since it was last
-- settled, then settle it where it stands.
DROP TRIGGER IF EXISTS stacker_plan_reconcile$
CREATE TRIGGER stacker_plan_reconcile AFTER UPDATE OF reconciles ON stacker_plan_ledger
FOR EACH ROW WHEN NEW.exposureplan_id IN (SELECT exposureplan_id FROM stacker_plan_quiet WHERE exposureplan_id = NEW.exposureplan_id)
BEGIN
    UPDATE stacker_plan_ledger
    SET fix = (SELECT min(s.accepted - s.accepted_images - stacker_plan_ledger.accepted_offset,
                          stacker_plan_ledger.applied)
               FROM stacker_plan_state s WHERE s.exposureplan_id = NEW.exposureplan_id)
    WHERE exposureplan_id = NEW.exposureplan_id
      AND applied > 0
      AND images = (SELECT count(*) FROM acquiredimage a
                    WHERE a.exposureId = NEW.exposureplan_id AND a.Id <= stacker_plan_ledger.max_id)
      AND accepted_offset < (SELECT s.accepted - s.accepted_images FROM stacker_plan_state s
                             WHERE s.exposureplan_id = NEW.exposureplan_id);

    UPDATE exposureplan
    SET accepted = accepted - (SELECT fix FROM stacker_plan_ledger WHERE exposureplan_id = NEW.exposureplan_id)
    WHERE Id = NEW.exposureplan_id
      AND (SELECT fix FROM stacker_plan_ledger WHERE exposureplan_id = NEW.exposureplan_id) > 0;

    UPDATE stacker_plan_ledger
    SET corrected = corrected + fix, fix = 0
    WHERE exposureplan_id = NEW.exposureplan_id AND fix > 0;

    UPDATE stacker_plan_ledger
    SET accepted_offset = (SELECT s.accepted - s.accepted_images FROM stacker_plan_state s WHERE s.exposureplan_id = NEW.exposureplan_id),
        images = (SELECT s.images FROM stacker_plan_state s WHERE s.exposureplan_id = NEW.exposureplan_id),
        max_id = (SELECT s.max_id FROM stacker_plan_state s WHERE s.exposureplan_id = NEW.exposureplan_id),
        updated_at = CAST(strftime('%s', 'now') AS INTEGER)
    WHERE exposureplan_id = NEW.exposureplan_id;
END$

-- Apply a verdict. An insert goes through the update trigger, so there is
-- one body; SymmetricDS applies an update only when a column changed, which
-- is what the stacker's attempt counter is for.
DROP TRIGGER IF EXISTS stacker_verdict_insert$
CREATE TRIGGER stacker_verdict_insert AFTER INSERT ON stacker_verdict
FOR EACH ROW
BEGIN
    UPDATE stacker_verdict SET attempt = attempt WHERE acquiredimage_id = NEW.acquiredimage_id;
END$

DROP TRIGGER IF EXISTS stacker_verdict_apply$
CREATE TRIGGER stacker_verdict_apply AFTER UPDATE ON stacker_verdict
FOR EACH ROW WHEN NEW.exposureplan_id IN (SELECT exposureplan_id FROM stacker_plan_quiet WHERE exposureplan_id = NEW.exposureplan_id)
BEGIN
    -- Not INSERT OR IGNORE: the conflict policy of the statement that fired
    -- the trigger (SymmetricDS's insert or upsert) would override it.
    INSERT INTO stacker_plan_ledger (exposureplan_id, accepted_offset, images, max_id, updated_at)
    SELECT s.exposureplan_id, s.accepted - s.accepted_images, s.images, s.max_id, CAST(strftime('%s', 'now') AS INTEGER)
    FROM stacker_plan_state s WHERE s.exposureplan_id = NEW.exposureplan_id
      AND NOT EXISTS (SELECT 1 FROM stacker_plan_ledger l WHERE l.exposureplan_id = NEW.exposureplan_id);

    UPDATE stacker_plan_ledger SET reconciles = reconciles + 1 WHERE exposureplan_id = NEW.exposureplan_id;

    -- Reject: only an image TS has Accepted, and one off the plan only if
    -- the image changed (changes() is the last statement's row count).
    UPDATE acquiredimage SET gradingStatus = 2, rejectreason = NEW.reason
    WHERE NEW.verdict = 2 AND Id = NEW.acquiredimage_id AND guid = NEW.guid
      AND exposureId = NEW.exposureplan_id AND gradingStatus = 1;
    UPDATE exposureplan SET accepted = accepted - 1
    WHERE changes() = 1 AND Id = NEW.exposureplan_id AND accepted > 0;
    UPDATE stacker_plan_ledger SET applied = applied + 1
    WHERE changes() = 1 AND exposureplan_id = NEW.exposureplan_id;

    -- Undo: only an image the stacker rejected, not one TS or a person did.
    UPDATE acquiredimage SET gradingStatus = 1, rejectreason = ''
    WHERE NEW.verdict = 1 AND Id = NEW.acquiredimage_id AND guid = NEW.guid
      AND exposureId = NEW.exposureplan_id AND gradingStatus = 2 AND rejectreason LIKE 'stacker:%';
    UPDATE exposureplan SET accepted = accepted + 1
    WHERE changes() = 1 AND Id = NEW.exposureplan_id;
    UPDATE stacker_plan_ledger SET applied = max(applied - 1, 0)
    WHERE changes() = 1 AND exposureplan_id = NEW.exposureplan_id;

    -- Settle again: a decrement keeps the offset, but one skipped at
    -- accepted = 0 moves it.
    UPDATE stacker_plan_ledger
    SET accepted_offset = (SELECT s.accepted - s.accepted_images FROM stacker_plan_state s WHERE s.exposureplan_id = NEW.exposureplan_id),
        images = (SELECT s.images FROM stacker_plan_state s WHERE s.exposureplan_id = NEW.exposureplan_id),
        max_id = (SELECT s.max_id FROM stacker_plan_state s WHERE s.exposureplan_id = NEW.exposureplan_id),
        updated_at = CAST(strftime('%s', 'now') AS INTEGER)
    WHERE exposureplan_id = NEW.exposureplan_id;
END$

DROP TRIGGER IF EXISTS stacker_reconcile_insert$
CREATE TRIGGER stacker_reconcile_insert AFTER INSERT ON stacker_reconcile
FOR EACH ROW
BEGIN
    UPDATE stacker_plan_ledger SET reconciles = reconciles + 1 WHERE exposureplan_id = NEW.exposureplan_id;
END$

DROP TRIGGER IF EXISTS stacker_reconcile_update$
CREATE TRIGGER stacker_reconcile_update AFTER UPDATE ON stacker_reconcile
FOR EACH ROW
BEGIN
    UPDATE stacker_plan_ledger SET reconciles = reconciles + 1 WHERE exposureplan_id = NEW.exposureplan_id;
END$

