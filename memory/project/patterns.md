# Project Memory Patterns

## Repeating repository patterns
- Documentation, skills, templates, and schemas all mirror the same workflow contract.
- Human-readable and machine-readable artifacts come in pairs:
  - `state.md` + `state.json`
  - `run-history.md` + `run-history.json`
- Stable IDs are part of the design:
  - `REQ-*` for requirements
  - `EVAL-*` for evals
  - `TASK-*` in task decomposition

## Authoring style
- Keep docs short, operational, and directive.
- Prefer explicit lists over narrative prose.
- Describe gates, evidence, rollback, and ownership directly.
- Reuse exact vocabulary across files instead of synonyms.

## Structural patterns
- `docs/workflow/` explains the per-phase model.
- `docs/roles/` tells who does what.
- `docs/standards/` encodes operational rules.
- `skills/` tells an agent how to behave inside the model.
- `templates/` give the expected artifact shapes.
- `memory/` should let a future Orchestrator orient quickly without broad rereads.

## Decision pattern
- Keep the main agent narrow.
- Delegate broad reading when more than one area or more than three files matter.
- Fan out only after planning is stable; fan in before VERIFY, REVIEW, and FINALIZE.

## Update pattern
- When workflow vocabulary changes, update README, workflow docs, skills, templates, and memory together.
- When artifact structure changes, check both Markdown and JSON forms plus schema references.
