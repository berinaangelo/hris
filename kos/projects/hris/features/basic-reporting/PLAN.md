# Basic Reporting — Plan

Status: post-MVP backlog — scoped, not committed to a version
Last updated: 2026-08-21

## One-sentence description

A handful of report views run aggregate queries against data the system
already has, so HR can answer common questions without asking anyone or
exporting to a spreadsheet.

## Core flow

HR opens Reports → picks one of a fixed set of views → optionally
filters by date range/department → sees a table → exports to CSV if
needed for finance or management. No report builder, no dashboard
configuration.

## How it works

No new data pipeline: reports are plain aggregate SQL (`COUNT`,
`GROUP BY`, `SUM`, date-range filters) against the same operational
tables the app already populates through normal use (employees,
leave_requests, payroll_runs). No separate reporting database, no ETL,
no BI tool integration.

## In scope

- Headcount snapshot — active employees by department
- New hires vs. departures — over a selected period
- Turnover count — departures over a period, by department (raw count,
  not a computed rate)
- Leave balances — remaining vs. used credits per employee
- Leave taken summary — total days taken per period, by department
- Payroll register — gross/net paid and total deductions per cutoff
- Statutory contributions summary — total SSS/PhilHealth/Pag-IBIG/BIR
  withheld per period
- CSV export on every view above

## Out of scope

- Trend charts/visualizations over time — start as a table; a chart is
  a later upgrade to an existing view, not a new build
- Turnover rate (departures ÷ average headcount) — a formula refinement
  once raw counts are actually in use
- Outstanding loans/cash advance report — wait until the loan ledger
  (see [[../payroll-v2/PLAN.md]]) has real volume
- Any report builder, custom filters beyond date/department, or
  scheduled/emailed reports
- A separate reporting database or BI integration
