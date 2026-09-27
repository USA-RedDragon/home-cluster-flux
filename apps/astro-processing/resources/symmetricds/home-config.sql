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
  ('acquiredimage', 'acquiredimage', 'default', 'reload', current_timestamp, current_timestamp),
  ('imagedata', 'imagedata', 'default', 'reload', current_timestamp, current_timestamp)
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

-- Make home request a reverse initial load (observatory -> home) whenever the
-- observatory registers from scratch.
insert into sym_parameter (external_id, node_group_id, param_key, param_value, create_time, last_update_time) values
  ('ALL', 'home', 'auto.reload.reverse', 'true', current_timestamp, current_timestamp)
  on conflict do nothing;

-- SymmetricDS creates the replicated tables as the symmetricds role; the
-- backend and pixinsight-worker read them as astro-processing.
alter default privileges for role symmetricds in schema public
  grant select on tables to "astro-processing";
