/*
    SQL Server Performance Investigation Lab
    Step 1: Create a synthetic reporting workload.

    Safety:
      - Creates a new database named PerformanceLab.
      - Stops if it already exists.
      - Inserts 250,000 fictional rows.
*/

USE master;
GO

IF DB_ID(N'PerformanceLab') IS NOT NULL
BEGIN
    THROW 51001, 'PerformanceLab already exists. Drop or rename the existing lab database manually before rerunning this script.', 1;
END;
GO

CREATE DATABASE PerformanceLab;
GO

USE PerformanceLab;
GO

CREATE TABLE dbo.ContributionTransaction
(
    ContributionId      bigint IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_ContributionTransaction PRIMARY KEY CLUSTERED,
    PIN                 varchar(12) NOT NULL,
    FundId              varchar(3) NOT NULL,
    ValueDate           date NOT NULL,
    TransactionType     varchar(20) NOT NULL,
    Amount              decimal(18,2) NOT NULL,
    ReferenceNo         varchar(40) NOT NULL,
    CreatedAt           datetime2(0) NOT NULL
        CONSTRAINT DF_ContributionTransaction_CreatedAt DEFAULT SYSDATETIME(),
    CONSTRAINT UQ_ContributionTransaction_ReferenceNo UNIQUE (ReferenceNo)
);
GO

;WITH Numbers AS
(
    SELECT TOP (250000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects AS a
    CROSS JOIN sys.all_objects AS b
)
INSERT dbo.ContributionTransaction
(
    PIN,
    FundId,
    ValueDate,
    TransactionType,
    Amount,
    ReferenceNo
)
SELECT
    CONCAT('PEN', RIGHT(CONCAT('000000000', ((n - 1) % 10000) + 1), 9)),
    RIGHT(CONCAT('00', ((n - 1) % 3) + 1), 3),
    DATEADD(DAY, (n - 1) % 1095, CONVERT(date, '2023-01-01')),
    CASE WHEN n % 7 = 0 THEN 'VOLUNTARY' ELSE 'MANDATORY' END,
    CAST(5000 + ((n % 200) * 125) AS decimal(18,2)),
    CONCAT('PERF-', RIGHT(CONCAT('0000000', n), 7))
FROM Numbers;
GO

CHECKPOINT;
GO

SELECT
    DatabaseName = DB_NAME(),
    TotalRows = COUNT_BIG(*),
    EarliestValueDate = MIN(ValueDate),
    LatestValueDate = MAX(ValueDate),
    DistinctPins = COUNT(DISTINCT PIN),
    DistinctFunds = COUNT(DISTINCT FundId)
FROM dbo.ContributionTransaction;
GO
