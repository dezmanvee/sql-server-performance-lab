/*
    SQL Server Performance Investigation Lab
    Step 6: Review index usage carefully.

    Important:
      - These DMV statistics reset when SQL Server restarts.
      - A low count does not prove that an index is unnecessary.
      - Do not remove indexes using this output alone.
*/

USE PerformanceLab;
GO

SELECT
    SqlServerServiceStartTime = sqlserver_start_time,
    CapturedAt = SYSDATETIME()
FROM sys.dm_os_sys_info;
GO

SELECT
    SchemaName = SCHEMA_NAME(o.schema_id),
    TableName = o.name,
    IndexName = i.name,
    IndexType = i.type_desc,
    UserSeeks = ISNULL(ius.user_seeks, 0),
    UserScans = ISNULL(ius.user_scans, 0),
    UserLookups = ISNULL(ius.user_lookups, 0),
    UserUpdates = ISNULL(ius.user_updates, 0),
    LastUserSeek = ius.last_user_seek,
    LastUserScan = ius.last_user_scan,
    LastUserLookup = ius.last_user_lookup,
    LastUserUpdate = ius.last_user_update
FROM sys.indexes AS i
INNER JOIN sys.objects AS o
    ON o.object_id = i.object_id
LEFT JOIN sys.dm_db_index_usage_stats AS ius
    ON ius.database_id = DB_ID()
   AND ius.object_id = i.object_id
   AND ius.index_id = i.index_id
WHERE o.object_id = OBJECT_ID(N'dbo.ContributionTransaction')
ORDER BY i.index_id;
GO
