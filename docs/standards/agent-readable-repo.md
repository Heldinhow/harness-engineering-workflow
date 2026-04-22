# Agent-Readable Repository

## Purpose

Make this repository navigable by agents with minimal context and maximum traceability.

## Read Order

Agents should read files in this priority order:

1. `AGENTS.md` — quick map and principles
2. `docs/workflow/overview.md` — layered overview
3. `docs/workflow/phases-and-gates.md` — phase table with gates and rollback
4. Feature state files — for active work
5. Detailed docs — only when needed for specific phase or role guidance

## Navigation Principles

- `AGENTS.md` is an index, not an encyclopedia.
- Detailed guidance lives in `docs/`, not in `AGENTS.md`.
- Memory docs orient without duplicating source files.
- Skills tell agents how to behave; docs tell them where to look.

## Artifact Filename Stability

Artifact filenames are literal and stable:

- `spec.md`, `design.md`, `tasks.md`, `eval.md`
- `execution-contract.md`, `review.md`, `finalize-report.md`
- `state.md`, `state.json`, `run-history.md`, `run-history.json`
- `delegation.md`, `codebase-reader-report.md`

Do not rename these files after they are created. The workflow depends on predictable filenames.

## Documentation Style

- Prefer short sections and bullets over narrative prose.
- State rules directly as obligations or constraints.
- Use exact vocabulary consistently; do not introduce synonyms for phase names, role names, or decision names.
- Every doc that references workflow vocabulary should use the canonical phase list.

## Progressive Disclosure Structure

```
AGENTS.md          → short index, points to docs
docs/workflow/     → phase lifecycle (per-phase .md files)
docs/roles/        → who does what
docs/standards/    → operational rules (rollback, evidence, parallelism, etc.)
templates/         → artifact shapes
skills/            → behavior guidance per role
schemas/           → machine-readable stability
memory/            → project and codebase orientation
```
