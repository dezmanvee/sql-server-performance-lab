/*
    SQL Server Performance Investigation Lab
    Step 2: Capture the baseline.

    SSMS instructions:
      1. Include Actual Execution Plan (Ctrl+M).
      2. Execute this script.
      3. Save the actual plan and capture the Messages tab for STATISTICS IO/TIME.

    Do not use DBCC FREEPROCCACHE outside a disposable local lab.
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
