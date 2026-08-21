---
title: ats-checker-reuse-parked-for-recruitment
tags: [hris, recruitment, reuse]
date: 2026-08-21
---

An existing tool at `~/Desktop/projects/ats-checker` was considered for
reuse in [[../projects/hris/features/recruitment-ats/PLAN.md|recruitment/ATS]].
Decision: keep it parked as a future bolt-on, don't let its existence
pull recruitment/ATS forward in the roadmap.

What the tool actually is: a **resume-vs-job-description match scorer**
— keyword coverage (60%) + semantic similarity via TensorFlow.js'
Universal Sentence Encoder running client-side (40%), plus regex-based
phrasing/weak-wording nudges and PDF layout checks (multi-column,
embedded images). Zero build step, vanilla JS. Not an Applicant Tracking
System — it doesn't handle postings, pipeline stages, or interview
scheduling.

Why it doesn't change the recruitment/ATS scope decision: "we already
partly built it" is explicitly the kind of justification the
ruthless-simplicity gate warns against (survives by inertia, not
because the core flow needs it). Whether recruitment/ATS gets built
depends on the HRIS's core flow needing it — reuse only affects *how
cheap* it is once that's true, not *whether* to build it now.

**Reuse plan, if/when recruitment/ATS is built:**
- `keywordExtractor.js`, `gapAnalysis.js`, `phrasingAnalyzer.js`,
  `scorer.js` — pure functions, no DOM/model coupling, portable as-is
  via Rails import maps.
- `similarityModel.js` (TF.js loading + cosine similarity) — also
  portable as-is, stays client-side, no Ruby ML equivalent needed.
- `resultsView.js` + `main.js` — touch the DOM directly; rewrite as a
  Stimulus controller instead of vanilla event wiring (see
  [[tech-stack-hotwire-over-coffeescript]]). This is the only real
  porting work.
- Fits as one feature *within* recruitment (auto-score incoming resumes
  for triage), not the recruitment module itself.
