---
title: basic-reporting-schema
tags: [hris, schema, database, basic-reporting]
date: 2026-08-23
---

Schema pass for
[[../../projects/hris/features/basic-reporting/PLAN.md|Basic
Reporting]]. **No new tables.** The PLAN is explicit about this: "no
new data pipeline... plain aggregate SQL against the same operational
tables the app already populates... no separate reporting database, no
ETL." This doc is the "summary tables unless deemed necessary"
precondition check for all 7 fixed reports — each one below, with the
existing table(s) it reads and the specific trigger that would turn it
into a real rollup candidate later.

| Report | Reads | Rollup trigger, if it ever comes |
|---|---|---|
| Headcount snapshot (active employees by department) | `employees` (`status`, `department`) — `WHERE status = active GROUP BY department`, covered by the `[company_id, status]` index in [[core-v1-schema]] | Only at a headcount [[core-v1-schema]] wasn't sized for (thousands of employees per company) — not an SME concern |
| New hires vs. departures (period) | `employees.start_date` / `last_working_day`, date-range filtered | Same as above |
| Turnover count (period, by department) | `employees.last_working_day`, date-range + `GROUP BY department` — raw count only, per the PLAN's explicit "not a computed rate" scope | Same as above |
| Leave balances (remaining vs. used) | `leave_balances` directly — **this is already the rollup table**, built in [[core-v1-schema]] specifically so this exact read is O(1) per employee, not a re-sum of `leave_requests` | None — already solved |
| Leave taken summary (period, by department) | `leave_requests` (`status: approved`, `start_date`/`end_date`) joined to `employees.department`, `SUM(days_requested) GROUP BY department` | Years of `leave_requests` history piling up across a large company — revisit only if this specific query is ever observed slow |
| Payroll register (gross/net/deductions per cutoff) | `payslips`, scoped to one `payroll_run_id`, `SUM(gross_pay)`/`SUM(net_pay)`/`SUM(total_deductions)` — see [[payroll-v2-schema]] | Scale is bounded by employees-per-cutoff (tens to low hundreds) — not a rollup candidate at SME size |
| Statutory contributions summary (period) | `payslip_line_items` where `line_type` in the four `statutory_*` values, date-range via `payslips → payroll_runs.period_*`, `SUM(amount) GROUP BY line_type` | Same bound as Payroll Register |

**Why none of these get a summary table now:** every one of them is a
single indexed aggregate over a table already sized for SME headcount
(tens to a few hundred employees, a few dozen payroll runs a year). The
PLAN's own explicit "no ETL, no separate reporting database" stance
rules out building one preemptively — the [[core-v1-schema|leave_balances
precedent]] shows this project *will* build a real rollup once a specific
screen actually needs O(1) reads under load; none of these seven do yet.

CSV export (every view) is a controller concern (`send_data` /
streaming per
[[../rails-pagination-and-batch-export-processing]]), not a schema
concern — no additional table for it either.

## Related decisions

- [[../../projects/hris/features/basic-reporting/PLAN.md]]
- [[core-v1-schema]]
- [[payroll-v2-schema]]
- [[../rails-pagination-and-batch-export-processing]]
