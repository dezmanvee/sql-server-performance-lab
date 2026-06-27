/*
    SQL Server Performance Investigation Lab
    Step 5: Rerun the exact baseline workload after the index change.

    SSMS instructions:
      1. Include Actual Execution Plan (Ctrl+M).
      2. Execute this script.
      3. Capture the actual plan and Messages tab.
      4. Compare only this run with the baseline script using the same parameters.
*/

USE PerformanceLab;
GO

SET NOCOUNT ON;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

DECLARE @FundId varchar(3) = '001';
DECLARE @StartDate date = '2025-01-01';
DECLARE @EndDate date = '2025-12-31';

SELECT
    ContributionMonth = CONVERT(char(7), ValueDate, 120),
    TransactionCount = COUNT_BIG(*),
    TotalContribution = SUM(Amount)
FROM dbo.ContributionTransaction
WHERE FundId = @FundId
  AND ValueDate >= @StartDate
  AND ValueDate < DATEADD(DAY, 1, @EndDate)
GROUP BY CONVERT(char(7), ValueDate, 120)
ORDER BY ContributionMonth
OPTION (RECOMPILE);
GO

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

-- Usage is meaningful only in context. The DMV resets when SQL Server restarts.
SELECT
    IndexName = i.name,
    UserSeeks = ISNULL(ius.user_seeks, 0),
    UserScans = ISNULL(ius.user_scans, 0),
    UserLookups = ISNULL(ius.user_lookups, 0),
    UserUpdates = ISNULL(ius.user_updates, 0),
    LastUserSeek = ius.last_user_seek,
    LastUserScan = ius.last_user_scan,
    LastUserUpdate = ius.last_user_update
FROM sys.indexes AS i
LEFT JOIN sys.dm_db_index_usage_stats AS ius
    ON ius.database_id = DB_ID()
   AND ius.object_id = i.object_id
   AND ius.index_id = i.index_id
WHERE i.object_id = OBJECT_ID(N'dbo.ContributionTransaction')
ORDER BY i.index_id;
GO
