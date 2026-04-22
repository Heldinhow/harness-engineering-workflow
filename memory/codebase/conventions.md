# Codebase Memory Conventions

## Vocabulary that should not drift
- Phases: `INTAKE`, `SPECIFY`, `DESIGN`, `TASKS`, `EXECUTION CONTRACT`, `EXECUTE`, `VERIFY`, `REVIEW`, `FINALIZE`
- Review decisions: `pass`, `rework`, `escalate`
- Execution classes: `sequential`, `parallelizable`, `blocked`
- Main role name: `Orchestrator`
- Broad-reading helper roles: `Codebase Reader`, `Implementer`, `Verifier`

## Documentation conventions
- Prefer short sections and bullets.
- State rules directly as obligations or constraints.
- Keep Markdown filenames stable and literal (`spec.md`, `eval.md`, `review.md`, etc.).
- Use repo-relative paths when referencing files.

## Contract conventions
- Delegated inputs stay minimal: objective, relevant IDs, allowed paths, required artifacts, readiness, done definition, dependencies.
- Delegated outputs stay filtered: relevant files, technical summary, expected impact, risks, dependencies, objective recommendations.
- Memory docs should help choose what to read next, not duplicate whole source files.

## Artifact conventions
- Markdown and JSON forms should stay aligned when paired.
- State and run history are treated as control artifacts, not optional notes.
- Review is a formal gate artifact, not an informal comment.
- `finalize-report.md` is the canonical closeout artifact; `report.md` is legacy.

## Repository-specific caution
- README, AGENTS, workflow docs, skills, templates, and memory intentionally echo each other.
- A terminology change in one of these areas usually requires coordinated edits in the others.
