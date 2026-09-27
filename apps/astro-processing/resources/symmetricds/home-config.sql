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

-- The observatory sends the reload, so it is the one that must create the
-- tables here first. auto.reload.reverse makes home request that reload
-- whenever the observatory registers from scratch.
insert into sym_parameter (external_id, node_group_id, param_key, param_value, create_time, last_update_time) values
  ('ALL', 'sqlite', 'initial.load.create.first', 'true', current_timestamp, current_timestamp),
  ('ALL', 'home', 'auto.reload.reverse', 'true', current_timestamp, current_timestamp)
  on conflict do nothing;

-- SymmetricDS creates the replicated tables as the symmetricds role; the
-- backend and pixinsight-worker read them as astro-processing.
alter default privileges for role symmetricds in schema public
  grant select on tables to "astro-processing";
