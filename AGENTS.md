# AGENTS.md

This repository defines an operational workflow package. Changes to this repository should model the same behavior the package recommends.

## Default Stance

- Treat the main agent as the `Orchestrator`.
- Keep the main agent's context narrow.
- Delegate broad codebase reading to scoped subagents.
- Prefer explicit gates over implied completion.
- Keep artifacts lightweight, but make them operational.

## Required Workflow Behavior

1. Create or update a feature working set under `.specs/features/<feature>/` before meaningful implementation.
2. Keep `spec.md` ahead of execution.
3. Keep `eval.md` ahead of meaningful behavior change.
4. Use `tasks.md` whenever work spans multiple files, phases, dependencies, or parallel lanes.
5. Use `review.md` for formal review decisions.
6. Keep `state.md` and `state.json` aligned.
7. Keep `run-history.md` and `run-history.json` aligned.

## Codebase Reading Policy

The Orchestrator may directly read:

- the user request
- feature artifacts under `.specs/features/<feature>/`
- root framing docs like `README.md` and `AGENTS.md`
- `memory/project/*` and `memory/codebase/*`
- a clearly local scope such as one file or one tight diff

Delegate to `Codebase Reader` subagents when:

- more than one subsystem matters
- more than three files are likely relevant
- module boundaries or dependencies are unclear
- impact analysis is needed
- broad rereading would pollute context

## Delegation Contract

Every delegated task should include only:

- objective
- relevant `REQ-*`
- relevant `EVAL-*` when applicable
- allowed paths or areas
- required artifacts
- ready definition
- done definition
- dependencies

Every delegated result should return only:

- relevant files
- technical summary
- expected impact
- risks
- dependencies
- objective recommendations

## Parallelism Policy

Every task should declare one of:

- `sequential`
- `parallelizable`
- `blocked`

Use `parallelizable` only when ownership boundaries are clear and fan-in can happen safely before verify/review.

## Gate Policy

Every relevant phase must define:

- entry assumptions
- exit conditions
- evidence
- rollback target on failure

Do not treat work as complete when `VERIFY`, `REVIEW`, or `REPORT` evidence is stale.

## Vocabulary

Use these terms consistently across docs, skills, templates, examples, and feature artifacts:

- phases: `INTAKE`, `SPECIFY`, `DESIGN`, `TASKS`, `EVAL DEFINE`, `EXECUTE`, `VERIFY`, `REVIEW`, `REPORT`, `FINISH`
- review decisions: `pass`, `rework`, `escalate`
- execution classes: `sequential`, `parallelizable`, `blocked`

## Review Standard

The reviewer decides:

- `pass` when requirements, evidence, and structure are acceptable
- `rework` when issues can be fixed inside the workflow
- `escalate` when the workflow needs human judgment or scope direction

## Resume Standard

When resuming work, read in this order:

1. `state.json`
2. `state.md`
3. latest `run-history.json` entry
4. `review.md` when present
5. only the feature artifacts referenced by current state

Avoid broad repo rereads unless rollback or stale memory requires it.

## Rework Prevention Checklist

Before claiming work is complete, verify:

- [ ] Evidence is fresh (captured after last relevant change)
- [ ] Rollback target is specific (phase name, not "earlier")
- [ ] State artifacts aligned (state.md and state.json agree)
- [ ] Run history updated (this phase transition recorded)
- [ ] Stale evidence marked (if any evidence is no longer valid)

## Common Rework Patterns

1. **Stale evidence pass**: Claiming completion with evidence from before recent changes
2. **Vague rollback**: "go back" instead of naming a specific phase
3. **State drift**: state.md and state.json disagreeing on current phase
4. **Skip verification**: Reporting done without running verification commands
5. **Unmapped requirements**: REQ-* without corresponding EVAL-* evidence
