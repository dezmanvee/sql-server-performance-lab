# Case Study: Baseline and Validation of a Targeted Index Change

## Problem

A monthly contribution aggregation query filters by `FundId` and `ValueDate`. In the baseline lab, the table has only its clustered primary key, so SQL Server has no focused nonclustered path for the tested filter pattern.

## Method

1. Create a reproducible synthetic table with 250,000 rows.
2. Run a parameterised monthly aggregation query with actual execution plan and `STATISTICS IO, TIME` enabled.
3. Record baseline logical reads, CPU time, elapsed time, and key plan operator.
4. Create one targeted nonclustered index on `(FundId, ValueDate)` including `Amount`.
5. Run the identical query using the same parameters.
6. Compare outcomes and state limitations.

## Evidence to publish

| Image | What it should show |
|---|---|
| `01-baseline-execution-plan.png` | Actual plan before the index. |
| `02-baseline-statistics-io.png` | Baseline logical reads and timing messages. |
| `03-index-created.png` | The new index exists with intended key and included columns. |
| `04-after-execution-plan.png` | Actual plan after the index. |
| `05-after-statistics-io.png` | Validation logical reads and timing messages. |
| `06-before-after-summary.png` | Your manually prepared comparison table. |

## Before/after comparison table

Fill this only after running the lab:

| Measure | Baseline | After index | Observation |
|---|---:|---:|---|
| Logical reads |  |  |  |
| CPU time (ms) |  |  |  |
| Elapsed time (ms) |  |  |  |
| Key plan operator |  |  |  |
| Rows returned |  |  |  |

## Result statement

> In the local synthetic workload, I measured the same monthly contribution aggregation query before and after a targeted index change. The conclusion is based on actual execution plans and `STATISTICS IO, TIME` output from the lab. The index design is specific to the tested predicates and workload, and it would require broader workload analysis before any production deployment.

## What this proves

- You know how to establish a baseline before tuning.
- You validate change with evidence instead of assumptions.
- You understand that an index change has read benefits and write/storage trade-offs.
- You avoid universal claims from a single test.
