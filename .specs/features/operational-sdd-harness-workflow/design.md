# Design: operational-sdd-harness-workflow

## Summary
Keep the repository small, but make its workflow operational by adding explicit orchestration contracts, clearer artifact responsibilities, review-specific gates, and resumable state/history artifacts.

## Approach
- Treat `README.md` and `AGENTS.md` as the top-level operating contract.
- Add focused workflow docs under `docs/workflow/` for phases, gates, roles, delegation, parallelism, codebase reading, and resume behavior.
- Keep the existing four skills, but revise them to share a stricter vocabulary and add one new `harness-review` skill for the formal review gate.
- Expand `templates/` in-place instead of introducing a deep nested directory structure, minimizing churn for adopters.
- Add `schemas/` only for `state.json` and `run-history.json` to keep machine-readable state explicit without introducing a runtime.
- Add `memory/` for reusable project and codebase context, and `examples/` to show the workflow in practice.

## Key Decisions
- DES-001: The orchestrator consolidates filtered outputs instead of absorbing raw codebase context.
- DES-002: Broad codebase reading is delegated through a standard `codebase-reader-report.md` contract.
- DES-003: `state.json` is canonical for machine-readable control state; `state.md` is the human summary.
- DES-004: `run-history.json` is the canonical append-only ledger; `run-history.md` is the human digest.
- DES-005: Review is a dedicated gate with decision semantics independent from the final report.

## Requirement Mapping
- REQ-001, REQ-002 → workflow docs, main skill, planning/evals skills, examples.
- REQ-003, REQ-005 → agent roles, delegation docs, codebase reading docs, delegation/report templates.
- REQ-004 → tasks template and execution guidance.
- REQ-006, REQ-007 → phases-and-gates doc, review skill, review template.
- REQ-008, REQ-009 → state/run templates and schemas, state-and-runs doc.
- REQ-010 → memory docs and example feature trees.

## Risks
- Terminology drift between README, workflow docs, and skills.
- Over-specifying the package into a pseudo-runtime.
- Examples diverging from the templates if not generated from the same vocabulary.

## Mitigations
- Reuse identical phase names and decision terms everywhere.
- Keep artifacts declarative rather than executable.
- Use the same IDs and field names across templates, schemas, and examples.
