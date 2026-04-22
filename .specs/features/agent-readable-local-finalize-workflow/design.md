# Design: agent-readable-local-finalize-workflow

## Summary
Shift the repository from a monolithic workflow description to a layered documentation model with a short root index, phase-specific docs, role-specific docs, and operational standards. Preserve the repo's current Orchestrator-first philosophy, but formalize `EXECUTION CONTRACT` and `FINALIZE`, collapse `EVAL DEFINE` into artifact discipline rather than phase vocabulary, and make local completion the explicit end state.

## Existing Context / Reuse
- Reuse the current Orchestrator/delegation philosophy from `AGENTS.md`, `README.md`, `docs/workflow/*`, and `skills/*`.
- Reuse `eval.md` as a standing artifact rather than deleting it.
- Reuse paired Markdown/JSON control artifacts and their schemas.
- Reuse delegation and codebase reader patterns as the base for subagent firewall rules.

## Key Decisions
- DES-001: Keep `AGENTS.md` short and index-like; move detailed operational rules into `docs/`.
- DES-002: Treat `docs/workflow/` as the lifecycle layer, `docs/roles/` as the responsibility layer, and `docs/standards/` as the operational rule layer.
- DES-003: Add `EXECUTION CONTRACT` as a first-class phase and template instead of overloading `tasks.md`.
- DES-004: Add `FINALIZE` as the formal local closeout phase and introduce `finalize-report.md` for structured handoff.
- DES-005: Preserve `eval.md`, but remove `EVAL DEFINE` from the canonical phase sequence.
- DES-006: Keep compatibility by preserving existing filenames where practical, while updating canonical vocabulary and examples.
- DES-007: Update installer assets so installed copies include the `docs/` tree required by the new short `AGENTS.md`.

## Requirement Mapping
- REQ-001 -> `AGENTS.md`, `README.md`, installer asset set
- REQ-002 -> new `docs/workflow/*`, `docs/roles/*`, `docs/standards/*`
- REQ-003 -> docs, skills, templates, schemas, memory, examples
- REQ-004 -> `templates/execution-contract.md`, workflow docs, skills, examples
- REQ-005 -> `templates/finalize-report.md`, finalize docs, examples, memory
- REQ-006 -> roles docs, standards docs, delegation template, skills
- REQ-007 -> workflow docs, standards docs, templates, skills, examples
- REQ-008 -> `templates/eval.md`, docs, skills, examples
- REQ-009 -> installer manifest and target messaging
- REQ-010 -> docs and skills with CI/CD content removed or demoted from the core path

## Risks
- Vocabulary drift between docs, templates, skills, schemas, and examples.
- Installed copies becoming less useful if `docs/` is not shipped.
- Legacy examples and historical features becoming inconsistent with new phase names.

## Mitigations
- Update README, docs, skills, templates, memory, schemas, and examples in one pass.
- Update installer manifest to ship `docs/` for full/adapted/fallback modes.
- Treat historical `.specs/features/*` snapshots as legacy examples unless directly edited.
