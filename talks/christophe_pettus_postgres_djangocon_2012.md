# Christophe Pettus - Postgres When It's Not your Job: Djangocon 2012

## Filesystem

use EX4 or XFS.

## Basic config

```txt
log_destination = 'csvlog'
log_directory = 'pg_log'
logging_collector = on
log_filename = 'postgres-%Y-%m-%d_%H%M%S'
log_rotation_age = 1d
log_rotation_size = 1GB
log_min_duration_statement = 250ms
log_checkpoints = on
log_connections = on
log_disconnections = on
log_lock_waits = on
log_temp_files = 0
```

## Resource configuration

* `shared_buffers` = Set to 25% of available memory up to 8GB
* `work_mem` = (2 * RAM) / max connections
* `maintenance_work_mem` = RAM / 16
* `effective_cache_size` = RAM / 2
* `max_connections` = no more than 400

## Do nots

* Don't do sessions in the database
* Constantly updated accumulator fields
* Don't put task queues in the database... that's what Redis is for
* Don't use the database as a filesystem for storing things like images (it'll do it, but you have a file system for this)
* Very long running transactions
* Using `INSERT` instead of `COPY` for bulk imports
* Don't mix high transactional functionality with high data warehouse analysis (do the data warehousing stuff on a slave database)
* Gigantic `IN` clauses

## Indexes

A good index has:
1. high selectivity on commonly performed queries
1. or... it is needed to enforce a constraint

Only the first column of a mulit-column index can be used separately

When trying to assess what needs an index, look at these two tables
* `pg_stat_user_tables` - shows sequential scans
* `pg_state_user_indexes` -shows index usage

... look for indexes that aren't being used very often and tables that are being sequentially scanned often.

## Quick diagnosis

You cycle between these two to see who is holding the lock the other process is waiting on

* `pg_stat_activity`
* `pg_locks`

