# SQL Server Performance Investigation Lab

A reproducible SQL Server 2022 lab demonstrating how to investigate a slow reporting query and validate a targeted nonclustered index using actual execution plans and measurable query statistics.

> **Scope:** Synthetic data only. The lab is a method demonstration, not a universal indexing recipe.
>
> **Safety:** Run only on a local lab or an authorised non-production instance. Do not publish production execution plans, query text, server details, or data.

## Case-study flow

```text
Problem → Baseline → Investigation → Change → Validation → Lessons learned
```

## Scenario

A reporting query filters contribution transactions by `FundId` and `ValueDate`, then aggregates contribution amount by month. The baseline environment has only the clustered primary key. The investigation captures the actual execution plan and `SET STATISTICS IO, TIME ON` output, adds a focused nonclustered index, and reruns the exact same query.

## Run sequence

| Order | Script | Purpose |
|---|---|---|
| 1 | `01_create_performance_lab.sql` | Creates `PerformanceLab` with 250,000 synthetic contribution rows. |
| 2 | `02_baseline_slow_query.sql` | Captures the baseline query and execution evidence before the index. |
| 3 | `03_capture_query_metrics.sql` | Captures supporting context: service start, table size, existing indexes. |
| 4 | `04_create_targeted_index.sql` | Creates a targeted index for the tested predicates and aggregate. |
| 5 | `05_validate_improvement.sql` | Reruns the exact same query and checks index use. |
| 6 | `06_index_usage_review.sql` | Reviews index usage cautiously with service-start context. |

## What to measure

For both baseline and validation runs, capture:

- Actual execution plan
- Logical reads from `SET STATISTICS IO`
- CPU time and elapsed time from `SET STATISTICS TIME`
- Number of rows returned

The improvement statement must be based on your own result, for example:

> In the local synthetic workload, the targeted index reduced logical reads from **[baseline]** to **[after]** for the tested monthly aggregation query. The actual plan changed from **[baseline operator]** to **[after operator]**.

Do not fill this in until you have run the lab.

## Why this is DBA evidence

This project does not claim that indexes should be added whenever a query is slow. It demonstrates a disciplined method: define the workload, measure the baseline, inspect the actual plan, make a narrow change, rerun the same workload, and document the outcome and trade-offs.

## Evidence checklist

See [`docs/CASE_STUDY.md`](docs/CASE_STUDY.md) and [`docs/images/README.md`](docs/images/README.md).

## Repository structure

```text
.
├── README.md
├── 01_create_performance_lab.sql
├── 02_baseline_slow_query.sql
├── 03_capture_query_metrics.sql
├── 04_create_targeted_index.sql
├── 05_validate_improvement.sql
├── 06_index_usage_review.sql
└── docs
    ├── CASE_STUDY.md
    └── images
        └── README.md
```
