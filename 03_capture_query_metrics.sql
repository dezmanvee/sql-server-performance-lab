/*
    SQL Server Performance Investigation Lab
    Step 3: Capture supporting context before the index change.

    This script does not replace execution-plan and STATISTICS IO/TIME evidence.
    It documents the environment around the tested object.
*/

USE PerformanceLab;
GO

SELECT
    SqlServerServiceStartTime = sqlserver_start_time,
    CapturedAt = SYSDATETIME()
FROM sys.dm_os_sys_info;
GO

SELECT
    TableName = QUOTENAME(OBJECT_SCHEMA_NAME(p.object_id)) + N'.' + QUOTENAME(OBJECT_NAME(p.object_id)),
    RowCount = SUM(p.rows),
    ReservedMB = CAST(SUM(au.total_pages) * 8.0 / 1024 AS decimal(18,2)),
    UsedMB = CAST(SUM(au.used_pages) * 8.0 / 1024 AS decimal(18,2))
FROM sys.partitions AS p
INNER JOIN sys.allocation_units AS au
    ON au.container_id = CASE WHEN au.type IN (1, 3) THEN p.hobt_id ELSE p.partition_id END
WHERE p.object_id = OBJECT_ID(N'dbo.ContributionTransaction')
  AND p.index_id IN (0, 1)
GROUP BY p.object_id;
GO

SELECT
    IndexName = i.name,
    IndexType = i.type_desc,
    IsUnique = i.is_unique,
    KeyColumns = STUFF
    (
        (
            SELECT N', ' + QUOTENAME(c.name) + CASE WHEN ic.is_descending_key = 1 THEN N' DESC' ELSE N' ASC' END
            FROM sys.index_columns AS ic
            INNER JOIN sys.columns AS c
                ON c.object_id = ic.object_id
               AND c.column_id = ic.column_id
            WHERE ic.object_id = i.object_id
              AND ic.index_id = i.index_id
              AND ic.is_included_column = 0
            ORDER BY ic.key_ordinal
            FOR XML PATH(''), TYPE
        ).value('.', 'nvarchar(max)'),
        1, 2, N''
    ),
    IncludedColumns = STUFF
    (
        (
            SELECT N', ' + QUOTENAME(c.name)
            FROM sys.index_columns AS ic
            INNER JOIN sys.columns AS c
                ON c.object_id = ic.object_id
               AND c.column_id = ic.column_id
            WHERE ic.object_id = i.object_id
              AND ic.index_id = i.index_id
              AND ic.is_included_column = 1
            ORDER BY ic.index_column_id
            FOR XML PATH(''), TYPE
        ).value('.', 'nvarchar(max)'),
        1, 2, N''
    )
FROM sys.indexes AS i
WHERE i.object_id = OBJECT_ID(N'dbo.ContributionTransaction')
ORDER BY i.index_id;
GO
