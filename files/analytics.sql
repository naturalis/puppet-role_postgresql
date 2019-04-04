-- Show server activity
SELECT row_to_json(t)
from (
SELECT *, 'pg_stat_activity' as tag FROM pg_stat_activity
) t;

-- Show accesses to tables and indexes
SELECT row_to_json(t)
from (
SELECT *, 'pg_stat_all_tables' as tag FROM pg_stat_all_tables
) t;

-- Show database-wide statistics
SELECT row_to_json(t)
from (
SELECT *, 'pg_stat_database' as tag FROM pg_stat_database
) t;

-- Show execution statistics of all SQL statements
SELECT row_to_json(t)
from (
SELECT *, 'pg_stat_statements' as tag FROM pg_stat_statements
) t;

-- Show statistics about I/O
SELECT row_to_json(t)
from (
SELECT *, 'pg_statio_all_tables' as tag,
((heap_blks_hit*100) / NULLIF((heap_blks_hit + heap_blks_read), 0)) AS heap_blks_cache_ratio,
((idx_blks_hit*100) / NULLIF((idx_blks_hit + idx_blks_read), 0)) AS idx_blks_cache_ratio,
((tidx_blks_hit*100) / NULLIF((tidx_blks_hit + tidx_blks_read), 0)) AS tidx_blks_cache_ratio,
((toast_blks_hit*100) / NULLIF((toast_blks_hit + toast_blks_read), 0)) AS toast_blks_cache_ratio
FROM pg_statio_all_tables
) t;

-- Show WAL archiver status
SELECT row_to_json(t)
from (
SELECT *, 'pg_stat_archiver' as tag from pg_stat_archiver
) t;

-- Show replication status from master server
SELECT row_to_json(t)
from (
SELECT *, 'pg_stat_replication' as tag from pg_stat_replication
) t;

-- Show replication status from standby server
SELECT row_to_json(t)
from (
SELECT *, 'pg_stat_wal_receiver' as tag from pg_stat_wal_receiver
) t;
