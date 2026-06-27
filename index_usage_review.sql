/*
Purpose: identify indexes with low read activity and write overhead.
Interpret results carefully; do not drop indexes solely from this output.
Requires VIEW SERVER STATE.
*/
SELECT
    DB_NAME() AS database_name,
    OBJECT_SCHEMA_NAME(i.object_id) AS schema_name,
    OBJECT_NAME(i.object_id) AS table_name,
    i.name AS index_name,
    i.type_desc,
    ISNULL(us.user_seeks, 0) AS user_seeks,
    ISNULL(us.user_scans, 0) AS user_scans,
    ISNULL(us.user_lookups, 0) AS user_lookups,
    ISNULL(us.user_updates, 0) AS user_updates,
    us.last_user_seek,
    us.last_user_scan,
    us.last_user_update
FROM sys.indexes i
LEFT JOIN sys.dm_db_index_usage_stats us
    ON us.database_id = DB_ID()
   AND us.object_id = i.object_id
   AND us.index_id = i.index_id
WHERE i.object_id > 100
  AND i.is_primary_key = 0
  AND i.is_unique_constraint = 0
ORDER BY user_updates DESC, user_seeks ASC;
