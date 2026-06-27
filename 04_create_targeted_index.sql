/*
    SQL Server Performance Investigation Lab
    Step 4: Create one targeted nonclustered index for the tested workload.

    Design rationale:
      - The query filters on FundId and a ValueDate range.
      - It aggregates Amount.
      - The index supports the filter and covers the aggregate without requiring a lookup
        for the tested query.

    This is a lab-specific decision. Evaluate write overhead, storage, competing queries,
    and business workload before applying a similar design in production.
*/

USE PerformanceLab;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE object_id = OBJECT_ID(N'dbo.ContributionTransaction')
      AND name = N'IX_ContributionTransaction_FundId_ValueDate'
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_ContributionTransaction_FundId_ValueDate
    ON dbo.ContributionTransaction (FundId, ValueDate)
    INCLUDE (Amount);
END;
GO

SELECT
    IndexName = i.name,
    IndexType = i.type_desc,
    IndexId = i.index_id,
    IsUnique = i.is_unique,
    FillFactor = i.fill_factor
FROM sys.indexes AS i
WHERE i.object_id = OBJECT_ID(N'dbo.ContributionTransaction')
ORDER BY i.index_id;
GO
