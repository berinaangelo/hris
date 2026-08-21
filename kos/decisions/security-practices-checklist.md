---
title: security-practices-checklist
tags: [hris, security, backend]
date: 2026-08-21
---

Standing security checklist for HRIS code, given the data at stake
(SSS/PhilHealth/Pag-IBIG/BIR numbers, salaries, bank details, personal
info).

1. **Strong Parameters, always explicit.** Never mass-assign raw
   `params` — `permit` the exact fields, especially on
   Employee/payroll forms.
2. **No raw SQL interpolation.** Parameterized queries / Arel
   ([[rails-arel-for-complex-queries]]) / the AR query interface only —
   never build a query string with interpolated user input.
3. **Devise for auth**, not hand-rolled login/session handling.
4. **Encrypt sensitive PII at rest.** SSS/PhilHealth/Pag-IBIG/BIR
   numbers and bank details use Rails 7's `encrypts :field`, not
   plaintext columns.
5. **Scrub sensitive fields from logs.** `config.filter_parameters` —
   salary, statutory IDs, passwords never land in plaintext logs.
6. **Secrets via Rails encrypted credentials or ENV — never
   hardcoded.** Global rule, not project-specific — same discipline
   applies here.
7. **CSV/export injection guard on Reports.** Any exported cell
   starting with `=`, `+`, `-`, `@` gets prefixed/escaped before
   export (formula-injection vector in spreadsheet exports).
8. **Brakeman + bundler-audit in CI**, run continuously, not as a
   one-time check.
