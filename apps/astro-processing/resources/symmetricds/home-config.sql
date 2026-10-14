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
create index if not exists acquiredimage_target_idx on acquiredimage ("targetId");
create index if not exists acquiredimage_project_idx on acquiredimage ("projectId");


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

create table if not exists ts_command (
    id text NOT NULL,
    kind text NOT NULL,
    payload text NOT NULL,
    author text NOT NULL,
    undo_of text,
    created_at timestamp NOT NULL,
    cancelled integer NOT NULL DEFAULT 0,
    PRIMARY KEY (id)
);

create table if not exists ts_command_result (
    command_id text NOT NULL,
    status text NOT NULL,
    message text,
    detail text,
    updated_at timestamp NOT NULL,
    PRIMARY KEY (command_id)
);

grant select, insert, update on ts_command to "astro-processing";
grant select on ts_command_result to "astro-processing";

insert into sym_channel (channel_id, processing_order, max_batch_size, max_batch_to_send, enabled, description, create_time, last_update_time) values
  ('command', 5, 20, 10, 1, 'web UI commands for observatory-scheduler', current_timestamp, current_timestamp)
  on conflict do nothing;

insert into sym_trigger (trigger_id, source_table_name, channel_id, reload_channel_id, create_time, last_update_time) values
  ('ts_command', 'ts_command', 'command', 'reload', current_timestamp, current_timestamp),
  ('ts_command_result', 'ts_command_result', 'command', 'reload', current_timestamp, current_timestamp)
  on conflict do nothing;

insert into sym_trigger_router (trigger_id, router_id, initial_load_order, create_time, last_update_time) values
  ('ts_command', 'home to sqlite', -1, current_timestamp, current_timestamp),
  ('ts_command_result', 'sqlite to home', -1, current_timestamp, current_timestamp)
  on conflict do nothing;

create table if not exists ts_goal (
    target_guid text NOT NULL,
    filter text NOT NULL,
    kind integer NOT NULL DEFAULT 0,
    snr_goal double precision NOT NULL DEFAULT 10,
    depth_goal double precision,
    plateau_stop integer NOT NULL DEFAULT 1,
    region text,
    updated_at text,
    PRIMARY KEY (target_guid, filter)
);

create table if not exists ts_goal_progress (
    target_guid text NOT NULL,
    filter text NOT NULL,
    kind integer,
    goal_value double precision,
    achieved_value double precision,
    progress double precision,
    snr double precision,
    depth double precision,
    effective_hours double precision,
    hours_needed double precision,
    gain_per_hour_pct double precision,
    plateau integer,
    low_confidence integer,
    done integer,
    measured_at timestamp,
    PRIMARY KEY (target_guid, filter)
);
alter table ts_goal_progress add column if not exists night_quality double precision;
alter table ts_goal_progress add column if not exists night_quality_at timestamp;
alter table ts_goal_progress add column if not exists season_boost double precision;
alter table ts_goal_progress add column if not exists state text;
alter table ts_goal_progress add column if not exists reason text;
alter table ts_goal_progress add column if not exists stack_subs integer;
alter table ts_goal_progress add column if not exists min_subs integer;
alter table ts_goal_progress add column if not exists sub_limit integer;

create table if not exists ts_target_season (
    target_guid text NOT NULL,
    nights_left integer,
    out_of_season integer,
    season_end text,
    computed_for text,
    computed_at text,
    PRIMARY KEY (target_guid)
);

grant select on ts_goal, ts_target_season to "astro-processing";
grant select, insert, update on ts_goal_progress to "astro-processing";
grant select on sym_node_identity, sym_node_host, sym_incoming_batch, sym_outgoing_batch to "astro-processing";

insert into sym_channel (channel_id, processing_order, max_batch_size, max_batch_to_send, enabled, description, create_time, last_update_time) values
  ('goal', 15, 50, 10, 1, 'observatory-scheduler goals, goal progress and seasons', current_timestamp, current_timestamp)
  on conflict do nothing;

insert into sym_trigger (trigger_id, source_table_name, channel_id, reload_channel_id, create_time, last_update_time) values
  ('ts_goal', 'ts_goal', 'goal', 'reload', current_timestamp, current_timestamp),
  ('ts_goal_progress', 'ts_goal_progress', 'goal', 'reload', current_timestamp, current_timestamp),
  ('ts_target_season', 'ts_target_season', 'goal', 'reload', current_timestamp, current_timestamp)
  on conflict do nothing;

insert into sym_trigger_router (trigger_id, router_id, initial_load_order, create_time, last_update_time) values
  ('ts_goal', 'sqlite to home', 120, current_timestamp, current_timestamp),
  ('ts_target_season', 'sqlite to home', 130, current_timestamp, current_timestamp),
  ('ts_goal_progress', 'home to sqlite', -1, current_timestamp, current_timestamp)
  on conflict do nothing;

create table if not exists ts_dark_need (
    combo_key text NOT NULL PRIMARY KEY,
    priority integer NOT NULL,
    exposure double precision NOT NULL,
    gain double precision NOT NULL,
    camera_offset double precision NOT NULL,
    binning double precision NOT NULL,
    readout_mode text,
    set_temp double precision NOT NULL,
    frames_needed integer NOT NULL,
    frames_have integer NOT NULL,
    frames_rejected integer NOT NULL,
    lights_blocked integer NOT NULL,
    lights_scaled integer NOT NULL,
    newest_dark_at timestamp,
    session_gap_hours double precision NOT NULL,
    basis text,
    computed_at timestamp NOT NULL
);

grant select, insert, update, delete on ts_dark_need to "astro-processing";

insert into sym_trigger (trigger_id, source_table_name, channel_id, reload_channel_id, create_time, last_update_time) values
  ('ts_dark_need', 'ts_dark_need', 'goal', 'reload', current_timestamp, current_timestamp)
  on conflict do nothing;

insert into sym_trigger_router (trigger_id, router_id, initial_load_order, create_time, last_update_time) values
  ('ts_dark_need', 'home to sqlite', -1, current_timestamp, current_timestamp)
  on conflict do nothing;

create table if not exists ts_bias_need (
    combo_key text NOT NULL PRIMARY KEY,
    priority integer NOT NULL,
    gain double precision NOT NULL,
    camera_offset double precision NOT NULL,
    binning double precision NOT NULL,
    readout_mode text,
    frames_needed integer NOT NULL,
    frames_have integer NOT NULL,
    newest_bias_at timestamp,
    session_gap_hours double precision NOT NULL,
    basis text,
    computed_at timestamp NOT NULL
);

create table if not exists ts_flat_request (
    request_id text NOT NULL PRIMARY KEY,
    target_id integer NOT NULL,
    target_name text NOT NULL,
    night text NOT NULL,
    filters text,
    requested_at timestamp NOT NULL,
    computed_at timestamp NOT NULL
);

grant select, insert, update, delete on ts_bias_need, ts_flat_request to "astro-processing";

insert into sym_trigger (trigger_id, source_table_name, channel_id, reload_channel_id, create_time, last_update_time) values
  ('ts_bias_need', 'ts_bias_need', 'goal', 'reload', current_timestamp, current_timestamp),
  ('ts_flat_request', 'ts_flat_request', 'goal', 'reload', current_timestamp, current_timestamp)
  on conflict do nothing;

insert into sym_trigger_router (trigger_id, router_id, initial_load_order, create_time, last_update_time) values
  ('ts_bias_need', 'home to sqlite', -1, current_timestamp, current_timestamp),
  ('ts_flat_request', 'home to sqlite', -1, current_timestamp, current_timestamp)
  on conflict do nothing;

create table if not exists ts_sub_length (
    target_guid text NOT NULL,
    filter text NOT NULL,
    gain integer NOT NULL,
    bucket text NOT NULL,
    exposure double precision NOT NULL,
    ideal double precision,
    current double precision,
    sky_rate double precision,
    snr_change double precision,
    basis text,
    computed_at timestamp NOT NULL,
    PRIMARY KEY (target_guid, filter, gain, bucket)
);

grant select, insert, update, delete on ts_sub_length to "astro-processing";

insert into sym_trigger (trigger_id, source_table_name, channel_id, reload_channel_id, create_time, last_update_time) values
  ('ts_sub_length', 'ts_sub_length', 'goal', 'reload', current_timestamp, current_timestamp)
  on conflict do nothing;

insert into sym_trigger_router (trigger_id, router_id, initial_load_order, create_time, last_update_time) values
  ('ts_sub_length', 'home to sqlite', -1, current_timestamp, current_timestamp)
  on conflict do nothing;

create table if not exists ts_autofocus_run (
    id text NOT NULL,
    profile_id text,
    started_at timestamp,
    finished_at timestamp NOT NULL,
    duration_seconds double precision,
    success integer NOT NULL,
    error text,
    filter text,
    temperature double precision,
    autofocuser text,
    method text,
    fitting text,
    initial_position double precision,
    previous_position double precision,
    previous_value double precision,
    chosen_position double precision,
    chosen_value double precision,
    points text NOT NULL,
    fit text,
    target_name text,
    target_guid text,
    source text NOT NULL,
    recorded_at timestamp NOT NULL,
    PRIMARY KEY (id)
);
create index if not exists ts_autofocus_run_finished_idx on ts_autofocus_run (finished_at);

grant select on ts_autofocus_run to "astro-processing";

insert into sym_channel (channel_id, processing_order, max_batch_size, max_batch_to_send, enabled, description, create_time, last_update_time) values
  ('autofocus', 20, 50, 10, 1, 'observatory-scheduler autofocus runs', current_timestamp, current_timestamp)
  on conflict do nothing;

insert into sym_trigger (trigger_id, source_table_name, channel_id, reload_channel_id, create_time, last_update_time) values
  ('ts_autofocus_run', 'ts_autofocus_run', 'autofocus', 'reload', current_timestamp, current_timestamp)
  on conflict do nothing;

insert into sym_trigger_router (trigger_id, router_id, initial_load_order, create_time, last_update_time) values
  ('ts_autofocus_run', 'sqlite to home', 140, current_timestamp, current_timestamp)
  on conflict do nothing;

create table if not exists ts_target_body (
    target_guid text NOT NULL PRIMARY KEY,
    designation text NOT NULL,
    kind text NOT NULL DEFAULT 'comet',
    updated_at text
);

create table if not exists ts_body_position (
    target_guid text NOT NULL,
    at timestamp NOT NULL,
    designation text NOT NULL,
    night text NOT NULL,
    ra double precision NOT NULL,
    dec double precision NOT NULL,
    ra_app double precision,
    dec_app double precision,
    ra_rate double precision NOT NULL,
    dec_rate double precision NOT NULL,
    mag double precision,
    delta double precision,
    unc_ra double precision,
    unc_dec double precision,
    computed_at timestamp NOT NULL,
    PRIMARY KEY (target_guid, at)
);

alter table ts_target_body add column if not exists rotation_deg double precision;
alter table ts_target_body add column if not exists offset_frac double precision;

grant select on ts_target_body to "astro-processing";
grant select, insert, update, delete on ts_body_position to "astro-processing";

insert into sym_trigger (trigger_id, source_table_name, channel_id, reload_channel_id, create_time, last_update_time) values
  ('ts_target_body', 'ts_target_body', 'goal', 'reload', current_timestamp, current_timestamp),
  ('ts_body_position', 'ts_body_position', 'goal', 'reload', current_timestamp, current_timestamp)
  on conflict do nothing;

insert into sym_trigger_router (trigger_id, router_id, initial_load_order, create_time, last_update_time) values
  ('ts_target_body', 'sqlite to home', 140, current_timestamp, current_timestamp),
  ('ts_body_position', 'home to sqlite', -1, current_timestamp, current_timestamp)
  on conflict do nothing;

create table if not exists ts_target_window (
    target_guid text NOT NULL PRIMARY KEY,
    start_utc text NOT NULL,
    end_utc text NOT NULL,
    priority text NOT NULL DEFAULT 'normal',
    event_id text,
    ignore_moon integer NOT NULL DEFAULT 0,
    updated_at text
);

grant select on ts_target_window to "astro-processing";

insert into sym_trigger (trigger_id, source_table_name, channel_id, reload_channel_id, create_time, last_update_time) values
  ('ts_target_window', 'ts_target_window', 'goal', 'reload', current_timestamp, current_timestamp)
  on conflict do nothing;

insert into sym_trigger_router (trigger_id, router_id, initial_load_order, create_time, last_update_time) values
  ('ts_target_window', 'sqlite to home', 141, current_timestamp, current_timestamp)
  on conflict do nothing;

create table if not exists ts_body_night (
    target_guid text NOT NULL,
    night text NOT NULL,
    at timestamp NOT NULL,
    designation text NOT NULL,
    ra double precision NOT NULL,
    dec double precision NOT NULL,
    ra_rate double precision NOT NULL,
    dec_rate double precision NOT NULL,
    mag double precision,
    mag_limit double precision,
    computed_at timestamp NOT NULL,
    PRIMARY KEY (target_guid, night)
);

grant select, insert, update, delete on ts_body_night to "astro-processing";

insert into sym_channel (channel_id, processing_order, max_batch_size, max_batch_to_send, enabled, description, create_time, last_update_time) values
  ('bodynight', 16, 200, 10, 1, 'observatory-scheduler body season nights', current_timestamp, current_timestamp)
  on conflict do nothing;

insert into sym_trigger (trigger_id, source_table_name, channel_id, reload_channel_id, create_time, last_update_time) values
  ('ts_body_night', 'ts_body_night', 'bodynight', 'reload', current_timestamp, current_timestamp)
  on conflict do nothing;

insert into sym_trigger_router (trigger_id, router_id, initial_load_order, create_time, last_update_time) values
  ('ts_body_night', 'home to sqlite', 150, current_timestamp, current_timestamp)
  on conflict do nothing;

create table if not exists ts_template_role (
    template_id integer NOT NULL PRIMARY KEY,
    template_guid text,
    profile_id text NOT NULL,
    filter text NOT NULL,
    role text NOT NULL,
    changed_at text NOT NULL
);

create table if not exists ts_template_migration (
    plan_id integer NOT NULL,
    plan_guid text,
    target_id integer,
    profile_id text NOT NULL,
    filter text NOT NULL,
    old_template_id integer NOT NULL,
    old_template_guid text,
    old_template_name text,
    new_template_id integer NOT NULL,
    migrated_at text NOT NULL,
    reverted_at text,
    PRIMARY KEY (plan_id, migrated_at)
);

grant select on ts_template_role to "astro-processing";
grant select on ts_template_migration to "astro-processing";

insert into sym_channel (channel_id, processing_order, max_batch_size, max_batch_to_send, enabled, description, create_time, last_update_time) values
  ('templates', 15, 1000, 10, 1, 'observatory-scheduler template roles and migration history', current_timestamp, current_timestamp)
  on conflict do nothing;

insert into sym_trigger (trigger_id, source_table_name, channel_id, reload_channel_id, create_time, last_update_time) values
  ('ts_template_role', 'ts_template_role', 'templates', 'reload', current_timestamp, current_timestamp),
  ('ts_template_migration', 'ts_template_migration', 'templates', 'reload', current_timestamp, current_timestamp)
  on conflict do nothing;

insert into sym_trigger_router (trigger_id, router_id, initial_load_order, create_time, last_update_time) values
  ('ts_template_role', 'sqlite to home', 150, current_timestamp, current_timestamp),
  ('ts_template_migration', 'sqlite to home', 151, current_timestamp, current_timestamp)
  on conflict do nothing;

create table if not exists ts_moon_keep (
    filter text NOT NULL,
    narrowband integer NOT NULL,
    moon_down integer NOT NULL,
    illum_bin integer NOT NULL,
    alt_bin integer NOT NULL,
    sep_bin integer NOT NULL,
    illum_from double precision NOT NULL,
    illum_to double precision NOT NULL,
    alt_from double precision NOT NULL,
    alt_to double precision NOT NULL,
    sep_from double precision NOT NULL,
    sep_to double precision NOT NULL,
    subs integer NOT NULL,
    kept integer NOT NULL,
    nights integer NOT NULL,
    rate double precision NOT NULL,
    rate_low double precision NOT NULL,
    rate_high double precision NOT NULL,
    worth double precision NOT NULL,
    usable integer NOT NULL,
    skips integer NOT NULL,
    computed_at timestamp NOT NULL,
    PRIMARY KEY (filter, narrowband, illum_bin, alt_bin, sep_bin)
);

grant select, insert, update, delete on ts_moon_keep to "astro-processing";

insert into sym_channel (channel_id, processing_order, max_batch_size, max_batch_to_send, enabled, description, create_time, last_update_time) values
  ('moonkeep', 17, 1000, 10, 1, 'astro-stacker kept rates under the Moon', current_timestamp, current_timestamp)
  on conflict do nothing;

insert into sym_trigger (trigger_id, source_table_name, channel_id, reload_channel_id, create_time, last_update_time) values
  ('ts_moon_keep', 'ts_moon_keep', 'moonkeep', 'reload', current_timestamp, current_timestamp)
  on conflict do nothing;

insert into sym_trigger_router (trigger_id, router_id, initial_load_order, create_time, last_update_time) values
  ('ts_moon_keep', 'home to sqlite', 160, current_timestamp, current_timestamp)
  on conflict do nothing;

create table if not exists ts_alt_keep (
    filter text NOT NULL,
    narrowband integer NOT NULL,
    alt_bin integer NOT NULL,
    alt_from double precision NOT NULL,
    alt_to double precision NOT NULL,
    subs integer NOT NULL,
    kept integer NOT NULL,
    nights integer NOT NULL,
    rate double precision NOT NULL,
    rate_low double precision NOT NULL,
    rate_high double precision NOT NULL,
    worth double precision NOT NULL,
    usable integer NOT NULL,
    skips integer NOT NULL,
    computed_at timestamp NOT NULL,
    PRIMARY KEY (filter, narrowband, alt_bin)
);

grant select, insert, update, delete on ts_alt_keep to "astro-processing";

insert into sym_channel (channel_id, processing_order, max_batch_size, max_batch_to_send, enabled, description, create_time, last_update_time) values
  ('altkeep', 18, 1000, 10, 1, 'astro-stacker kept rates by target altitude', current_timestamp, current_timestamp)
  on conflict do nothing;

insert into sym_trigger (trigger_id, source_table_name, channel_id, reload_channel_id, create_time, last_update_time) values
  ('ts_alt_keep', 'ts_alt_keep', 'altkeep', 'reload', current_timestamp, current_timestamp)
  on conflict do nothing;

insert into sym_trigger_router (trigger_id, router_id, initial_load_order, create_time, last_update_time) values
  ('ts_alt_keep', 'home to sqlite', 161, current_timestamp, current_timestamp)
  on conflict do nothing;

create table if not exists ts_cooler_setpoint (
    id text NOT NULL PRIMARY KEY,
    decided_at timestamp NOT NULL,
    night text NOT NULL,
    action text NOT NULL,
    outcome text NOT NULL,
    from_setpoint double precision,
    setpoint double precision,
    power double precision,
    ambient double precision,
    predicted_power double precision,
    target_power double precision NOT NULL,
    low_power double precision NOT NULL,
    high_power double precision NOT NULL,
    max_predicted_power double precision NOT NULL,
    fit_intercept double precision,
    fit_slope double precision,
    fit_samples integer,
    reason text NOT NULL
);

create index if not exists ts_cooler_setpoint_night_idx on ts_cooler_setpoint (night, decided_at);

grant select on ts_cooler_setpoint to "astro-processing";

insert into sym_channel (channel_id, processing_order, max_batch_size, max_batch_to_send, enabled, description, create_time, last_update_time) values
  ('cooler', 19, 1000, 10, 1, 'observatory-scheduler cooler setpoint decisions', current_timestamp, current_timestamp)
  on conflict do nothing;

insert into sym_trigger (trigger_id, source_table_name, channel_id, reload_channel_id, create_time, last_update_time) values
  ('ts_cooler_setpoint', 'ts_cooler_setpoint', 'cooler', 'reload', current_timestamp, current_timestamp)
  on conflict do nothing;

insert into sym_trigger_router (trigger_id, router_id, initial_load_order, create_time, last_update_time) values
  ('ts_cooler_setpoint', 'sqlite to home', 170, current_timestamp, current_timestamp)
  on conflict do nothing;
