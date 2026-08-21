---
title: navigation-me-team-company
tags: [hris, design, navigation, ia]
date: 2026-08-21
---

Chose "Me / Team / Company" for the HRIS navigation structure — a
top-level switcher — over two other proposed options ("Unified
Sidebar": one filtered list for everyone; "Dashboard-First": minimal
top bar, the home dashboard does the navigating). Full comparison with
each role's view: https://claude.ai/code/artifact/cdff8457-0fdf-48ea-b788-76c9cdc60dad

**Structure:**
- **Me** (everyone) — Home, My Profile, Time Off, My Reviews, My
  Payslips. The stable self-service home every role lands on by
  default.
- **Team** (managers and up) — Approvals, Team Calendar, Team Reviews.
- **Company** (HR Admin only) — People Directory, Payroll, Reports,
  Recruitment, Compliance. Every future backlog feature (see
  [[../projects/hris/PLAN.md|roadmap tiers]]) lands here.

A role that can't access a tab doesn't see it exist at all — not a
filtered-down list, an absent tab.

Why this one over the alternatives: it's the only option of the three
that scales as the backlog lands (recruitment, benefits, compliance,
time & attendance all fold into "Company" without lengthening what an
employee or manager sees daily) — the Unified Sidebar option was
rejected specifically because it has no such ceiling and was already
projected to hit 10+ items for HR Admin once the backlog ships. It also
keeps every role's "Me" screen the anchor for the v1 god-moments (see
[[../projects/hris/PLAN.md]]), rather than burying self-service under
admin tooling.

The Dashboard-First option's instinct — surface the god-moments as
cards on the landing screen — is worth carrying into how the Me/Team/
Company landing screens themselves get designed, even though it lost as
the primary nav pattern.
