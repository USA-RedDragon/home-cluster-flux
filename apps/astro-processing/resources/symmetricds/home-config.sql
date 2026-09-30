-- SymmetricDS replication config for the observatory's Target Scheduler
-- SQLite database (group "sqlite") into schedulerdb (group "home").
--
-- SymmetricDS keeps this config only in its own sym_* tables, and nodes pull
-- it from the registration server. If schedulerdb is ever rebuilt empty, the
-- observatory re-registers, receives an empty config and drops its capture
-- triggers, which is how this was lost in April 2026. This file is the source
-- of truth: SymmetricDS runs it (auto.config.registration.svr.sql.script)
-- whenever it starts against a database with no node identity. It is
-- idempotent, so it is also safe to apply by hand with psql.

-- SymmetricDS creates the replicated tables as the symmetricds role; the
-- backend, astro-stacker and pixinsight-worker read them as astro-processing.
-- First, so that it covers the tables created below too.
alter default privileges for role symmetricds in schema public
  grant select on tables to "astro-processing";

-- Target Scheduler tables. The SQLite source declares bare VARCHAR, which
-- SymmetricDS would create here as varchar(254); acquiredimage.metadata
-- outgrows that, and imagedata.imagedata holds image blobs. So the schema is
-- defined here rather than by initial.load.create.first. Column names are
-- quoted to match the SQLite casing the backend's gorm models use.
create table if not exists project (
    "Id" integer NOT NULL,
    "profileId" text NOT NULL,
    name text NOT NULL,
    description text,
    state integer,
    priority integer,
    createdate integer,
    activedate integer,
    inactivedate integer,
    minimumtime integer,
    minimumaltitude double precision,
    usecustomhorizon integer,
    horizonoffset double precision,
    meridianwindow integer,
    filterswitchfrequency integer,
    ditherevery integer,
    enablegrader integer,
    "isMosaic" integer NOT NULL,
    "flatsHandling" integer NOT NULL,
    "maximumAltitude" double precision,
    smartexposureorder integer,
    guid text,
    PRIMARY KEY ("Id")
);

create table if not exists target (
    "Id" integer NOT NULL,
    name text NOT NULL,
    active integer NOT NULL,
    ra double precision,
    "dec" double precision,
    epochcode integer NOT NULL,
    rotation double precision,
    roi double precision,
    projectid integer,
    "unusedOEO" text,
    guid text,
    PRIMARY KEY ("Id")
);

create table if not exists exposuretemplate (
    "Id" integer NOT NULL,
    "profileId" text NOT NULL,
    name text NOT NULL,
    filtername text NOT NULL,
    gain integer,
    "offset" integer,
    bin integer,
    readoutmode integer,
    twilightlevel integer,
    moonavoidanceenabled integer,
    moonavoidanceseparation double precision,
    moonavoidancewidth integer,
    maximumhumidity double precision,
    defaultexposure double precision,
    moonrelaxscale double precision,
    moonrelaxmaxaltitude double precision,
    moonrelaxminaltitude double precision,
    moondownenabled integer,
    ditherevery integer,
    "minutesOffset" integer,
    guid text,
    PRIMARY KEY ("Id")
);

create table if not exists exposureplan (
    "Id" integer NOT NULL,
    "profileId" text NOT NULL,
    exposure double precision NOT NULL,
    desired integer,
    acquired integer,
    accepted integer,
    targetid integer,
    "exposureTemplateId" integer,
    enabled integer,
    guid text,
    PRIMARY KEY ("Id")
);

create table if not exists filtercadenceitem (
    "Id" integer NOT NULL,
    targetid integer NOT NULL,
    "order" integer NOT NULL,
    next integer,
    action integer NOT NULL,
    "referenceIdx" integer,
    PRIMARY KEY ("Id")
);

create table if not exists overrideexposureorderitem (
    "Id" integer NOT NULL,
    targetid integer NOT NULL,
    "order" integer NOT NULL,
    action integer NOT NULL,
    "referenceIdx" integer,
    PRIMARY KEY ("Id")
);

create table if not exists ruleweight (
    "Id" integer NOT NULL,
    name text NOT NULL,
    weight double precision NOT NULL,
    projectid integer,
    PRIMARY KEY ("Id")
);

create table if not exists profilepreference (
    "Id" integer NOT NULL,
    "profileId" text NOT NULL,
    "enableGradeRMS" integer,
    "enableGradeStars" integer,
    "enableGradeHFR" integer,
    "maxGradingSampleSize" integer,
    "rmsPixelThreshold" double precision,
    "detectedStarsSigmaFactor" double precision,
    "hfrSigmaFactor" double precision,
    acceptimprovement integer,
    exposurethrottle double precision,
    parkonwait integer,
    "enableSmartPlanWindow" integer,
    "enableSynchronization" integer,
    "syncWaitTimeout" integer,
    "syncActionTimeout" integer,
    "syncSolveRotateTimeout" integer,
    "enableMoveRejected" integer,
    "enableGradeFWHM" integer,
    "enableGradeEccentricity" integer,
    "fwhmSigmaFactor" integer,
    "eccentricitySigmaFactor" integer,
    "enableDeleteAcquiredImagesWithTarget" integer,
    "syncEventContainerTimeout" integer,
    "delayGrading" double precision,
    "autoAcceptLevelHFR" double precision,
    "autoAcceptLevelFWHM" double precision,
    "autoAcceptLevelEccentricity" double precision,
    "enableSimulatedRun" integer,
    "skipSimulatedWaits" integer,
    "skipSimulatedUpdates" integer,
    "enableSlewCenter" integer,
    "logLevel" integer,
    "enableStopOnHumidity" integer,
    guid text,
    "enableProfileTargetCompletionReset" integer,
    PRIMARY KEY ("Id")
);

create table if not exists flathistory (
    "Id" integer NOT NULL,
    "targetId" integer,
    "lightSessionDate" integer,
    "flatsTakenDate" integer,
    "profileId" text NOT NULL,
    "flatsType" text,
    "filterName" text,
    gain integer,
    "offset" integer,
    bin integer,
    readoutmode integer,
    rotation double precision,
    roi double precision,
    "lightSessionId" integer NOT NULL,
    PRIMARY KEY ("Id")
);

create table if not exists acquiredimage (
    "Id" integer NOT NULL,
    "projectId" integer NOT NULL,
    "targetId" integer NOT NULL,
    acquireddate integer,
    filtername text NOT NULL,
    "gradingStatus" integer NOT NULL,
    metadata text NOT NULL,
    rejectreason text,
    "profileId" text,
    "exposureId" integer,
    guid text,
    PRIMARY KEY ("Id")
);

create table if not exists imagedata (
    "Id" integer NOT NULL,
    tag text,
    imagedata bytea,
    acquiredimageid integer,
    width integer,
    height integer,
    PRIMARY KEY ("Id")
);

insert into sym_node_group (node_group_id) values ('home'), ('sqlite')
  on conflict do nothing;

-- sqlite pushes its changes to home; home waits for sqlite to pull config.
insert into sym_node_group_link (source_node_group_id, target_node_group_id, data_event_action, create_time, last_update_time) values
  ('sqlite', 'home', 'P', current_timestamp, current_timestamp),
  ('home', 'sqlite', 'W', current_timestamp, current_timestamp)
  on conflict do nothing;

insert into sym_router (router_id, source_node_group_id, target_node_group_id, router_type, create_time, last_update_time) values
  ('sqlite to home', 'sqlite', 'home', 'default', current_timestamp, current_timestamp),
  ('home to sqlite', 'home', 'sqlite', 'default', current_timestamp, current_timestamp)
  on conflict do nothing;

insert into sym_trigger (trigger_id, source_table_name, channel_id, reload_channel_id, create_time, last_update_time) values
  ('project', 'project', 'default', 'reload', current_timestamp, current_timestamp),
  ('target', 'target', 'default', 'reload', current_timestamp, current_timestamp),
  ('exposuretemplate', 'exposuretemplate', 'default', 'reload', current_timestamp, current_timestamp),
  ('exposureplan', 'exposureplan', 'default', 'reload', current_timestamp, current_timestamp),
  ('filtercadenceitem', 'filtercadenceitem', 'default', 'reload', current_timestamp, current_timestamp),
  ('overrideexposureorderitem', 'overrideexposureorderitem', 'default', 'reload', current_timestamp, current_timestamp),
  ('ruleweight', 'ruleweight', 'default', 'reload', current_timestamp, current_timestamp),
  ('profilepreference', 'profilepreference', 'default', 'reload', current_timestamp, current_timestamp),
  ('flathistory', 'flathistory', 'default', 'reload', current_timestamp, current_timestamp),
  ('acquiredimage', 'acquiredimage', 'default', 'reload', current_timestamp, current_timestamp)
  on conflict do nothing;

-- imagedata.imagedata holds thumbnails that Target Scheduler has stored both
-- as blobs and as base64 text, which SymmetricDS cannot load into one bytea
-- column. Nothing here reads it, so replicate the metadata only.
insert into sym_trigger (trigger_id, source_table_name, channel_id, reload_channel_id, excluded_column_names, create_time, last_update_time) values
  ('imagedata', 'imagedata', 'default', 'reload', 'imagedata', current_timestamp, current_timestamp)
  on conflict do nothing;

insert into sym_trigger_router (trigger_id, router_id, initial_load_order, create_time, last_update_time) values
  ('project', 'sqlite to home', 10, current_timestamp, current_timestamp),
  ('target', 'sqlite to home', 20, current_timestamp, current_timestamp),
  ('exposuretemplate', 'sqlite to home', 30, current_timestamp, current_timestamp),
  ('exposureplan', 'sqlite to home', 40, current_timestamp, current_timestamp),
  ('filtercadenceitem', 'sqlite to home', 50, current_timestamp, current_timestamp),
  ('overrideexposureorderitem', 'sqlite to home', 60, current_timestamp, current_timestamp),
  ('ruleweight', 'sqlite to home', 70, current_timestamp, current_timestamp),
  ('profilepreference', 'sqlite to home', 80, current_timestamp, current_timestamp),
  ('flathistory', 'sqlite to home', 90, current_timestamp, current_timestamp),
  ('acquiredimage', 'sqlite to home', 100, current_timestamp, current_timestamp),
  ('imagedata', 'sqlite to home', 110, current_timestamp, current_timestamp)
  on conflict do nothing;

-- astro-stacker's verdicts on subs (low sky, moon) go the other way, home ->
-- observatory, where observatory-verdicts.sql applies them to Target
-- Scheduler: the sub is Rejected and its exposure plan's accepted count drops,
-- so TS images the target further. stacker_reconcile asks the observatory to
-- repair a plan's accepted count. That script is not run here: it goes to the
-- observatory once, by hand, as an SQL event (see its header).
create table if not exists stacker_verdict (
    acquiredimage_id integer NOT NULL,
    guid text NOT NULL,
    exposureplan_id integer NOT NULL,
    verdict integer NOT NULL,
    reason text NOT NULL,
    attempt integer NOT NULL DEFAULT 0,
    created_at timestamp NOT NULL DEFAULT (now() at time zone 'utc'),
    updated_at timestamp NOT NULL DEFAULT (now() at time zone 'utc'),
    PRIMARY KEY (acquiredimage_id)
);

create table if not exists stacker_reconcile (
    exposureplan_id integer NOT NULL,
    attempt integer NOT NULL DEFAULT 0,
    updated_at timestamp NOT NULL DEFAULT (now() at time zone 'utc'),
    PRIMARY KEY (exposureplan_id)
);

-- astro-stacker writes them as astro-processing, and SymmetricDS's capture
-- triggers run as the role that writes (postgres.security.definer is off).
grant select, insert, update on stacker_verdict, stacker_reconcile to "astro-processing";
grant insert on sym_data to "astro-processing";
grant usage on sequence sym_data_data_id_seq to "astro-processing";

-- Their own channel, in batches of 50: each batch is one transaction holding
-- the observatory database's write lock, and TS waits at most 5 s for it.
insert into sym_channel (channel_id, processing_order, max_batch_size, max_batch_to_send, enabled, description, create_time, last_update_time) values
  ('verdict', 10, 50, 10, 1, 'astro-stacker verdicts for Target Scheduler', current_timestamp, current_timestamp)
  on conflict do nothing;

insert into sym_trigger (trigger_id, source_table_name, channel_id, reload_channel_id, create_time, last_update_time) values
  ('stacker_verdict', 'stacker_verdict', 'verdict', 'reload', current_timestamp, current_timestamp),
  ('stacker_reconcile', 'stacker_reconcile', 'verdict', 'reload', current_timestamp, current_timestamp)
  on conflict do nothing;

-- Never in an initial load: a verdict is applied by a trigger when it
-- arrives, and the stacker sends again any that did not take.
insert into sym_trigger_router (trigger_id, router_id, initial_load_order, create_time, last_update_time) values
  ('stacker_verdict', 'home to sqlite', -1, current_timestamp, current_timestamp),
  ('stacker_reconcile', 'home to sqlite', -1, current_timestamp, current_timestamp)
  on conflict do nothing;

-- The observatory's trigger rejects images and lowers accepted while
-- SymmetricDS loads the verdict, when capture is normally off. Capture those
-- changes anyway (sync_on_incoming_batch), and route them back to home, where
-- the verdict came from (ping_back_enabled), so the stacker sees them applied.
-- Nothing routes these tables from home, so they cannot loop.
update sym_trigger set sync_on_incoming_batch = 1, last_update_time = current_timestamp
  where trigger_id in ('acquiredimage', 'exposureplan') and sync_on_incoming_batch <> 1;
update sym_trigger_router set ping_back_enabled = 1, last_update_time = current_timestamp
  where trigger_id in ('acquiredimage', 'exposureplan') and router_id = 'sqlite to home' and ping_back_enabled <> 1;

-- Make home request a reverse initial load (observatory -> home) whenever the
-- observatory registers from scratch.
insert into sym_parameter (external_id, node_group_id, param_key, param_value, create_time, last_update_time) values
  ('ALL', 'home', 'auto.reload.reverse', 'true', current_timestamp, current_timestamp)
  on conflict do nothing;
