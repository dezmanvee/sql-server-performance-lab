# Evidence Capture Guide — Performance Investigation Lab

All screenshots must come from the `PerformanceLab` database created by this repository.

## Before running the baseline and validation queries

1. In SSMS, select **Query → Include Actual Execution Plan** or press `Ctrl+M`.
2. Run the script.
3. Capture the actual plan tab and the Messages tab separately.
4. Keep the query parameters identical for baseline and validation.

## Screenshot list

### 01-baseline-execution-plan.png

Run `02_baseline_slow_query.sql` before creating the index.

**Capture:** the actual execution plan.

**Caption:** `Baseline plan for the synthetic monthly contribution aggregation before the targeted index.`

### 02-baseline-statistics-io.png

Capture the Messages tab from the same baseline run.

**Caption:** `Baseline logical reads and timing output captured with STATISTICS IO and TIME enabled.`

### 03-index-created.png

Run `04_create_targeted_index.sql`.

**Capture:** result grid that lists `IX_ContributionTransaction_FundId_ValueDate`.

**Caption:** `Targeted nonclustered index created for the lab query predicates and aggregate.`

### 04-after-execution-plan.png

Run `05_validate_improvement.sql`.

**Capture:** the actual execution plan.

**Caption:** `Actual plan for the same workload after the targeted index change.`

### 05-after-statistics-io.png

Capture the Messages tab from validation.

**Caption:** `Validation logical reads and timing output for the identical test workload.`

### 06-before-after-summary.png

Create a small Markdown table or an image using your genuine measured results.

**Caption:** `Measured before-and-after comparison for the local synthetic workload.`

## Screenshot quality rules

- Do not crop out the metric labels or plan operators needed for interpretation.
- Do not show unrelated production connections, object names, server names, or user information.
- Do not alter values; rerun the synthetic lab when you need cleaner evidence.
- Do not claim a percentage improvement unless it is calculated from your own captured measurements.
