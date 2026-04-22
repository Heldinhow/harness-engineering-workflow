# Phases And Gates

Each phase defines entry assumptions, required evidence, an exit gate, and a rollback target.

| Phase | Entry assumptions | Purpose | Required evidence | Gate to exit | Rollback target on failure |
| --- | --- | --- | --- | --- | --- |
| INTAKE | a request or change target exists | define feature id, scope, complexity, owner | feature name or slug, complexity rationale | work is classified | INTAKE |
| SPECIFY | feature id and local goal are known | define the contract | `spec.md` with scope and `REQ-*` | requirements are clear and testable | SPECIFY |
| DESIGN | `spec.md` exists and structure matters | define structure when needed | `design.md` with decisions and mappings | structure is explicit enough to execute/review | DESIGN or SPECIFY |
| TASKS | `spec.md` exists and decomposition is needed | decompose work | `tasks.md` with deps and execution classes | work units are scoped and traceable | TASKS or DESIGN |
| EXECUTION CONTRACT | tasks are stable enough for implementation | lock exact run scope | `execution-contract.md` | run scope is locked with done criteria and rollback routing | TASKS |
| EXECUTE | planning and contract artifacts are stable enough | perform the work | task evidence, delegated results, updated state | tasks are complete or explicitly blocked | EXECUTE, TASKS, or DESIGN |
| VERIFY | execution produced a candidate implementation or artifact set | prove current status | fresh command or inspection evidence | current claim is proven now | EXECUTE |
| REVIEW | fresh verify evidence and current artifacts exist | decide readiness quality | `review.md` with findings and decision | decision is `pass`, `rework`, or `escalate` | VERIFY, EXECUTE, or DESIGN |
| FINALIZE | review passed and all gates are green | close locally with tests and evidence | `finalize-report.md` plus referenced evidence | feature is ready to handoff | REVIEW or VERIFY |

## Gate Rules

### INTAKE Gate
- Establishes feature identity and complexity classification.
- Determines whether design, tasks, or execution contract are needed.

### SPECIFY Gate
- Blocks execution when requirements are vague or contradictory.
- Must answer what is in scope and what is out of scope.

### DESIGN Gate (Conditional)
- Enters only when structure, interfaces, data flow, or trade-offs matter.
- Skipped for clearly local small work.
- When entered, must produce decisions explicit enough to execute against.

### TASKS Gate
- Work must be decomposed into traceable, verifiable units.
- Each task must declare execution class and dependencies.

### EXECUTION CONTRACT Gate
- Locks the exact run scope, included/excluded tasks, dependencies, parallelism, expected surfaces, mandatory tests, done criteria, and rollback routing.
- Required before real implementation work begins.
- Prevents scope drift during execution.

### EXECUTE Gate
- Allows partial progress but not vague progress.
- Tasks must either be done, blocked with cause, or not started.

### VERIFY Gate
- Requires fresh evidence captured after the last relevant change.
- Old evidence is stale after relevant changes.

### REVIEW Gate
- Uses only three decisions: `pass`, `rework`, `escalate`.
- `rework` stays inside the workflow.
- `escalate` requests human judgment and is a decision, not a workflow phase.

### FINALIZE Gate
- Requires implementation complete, tests executed, evidence organized, artifacts synchronized, state consistent, residual debt recorded, and handoff legible.
- Is the terminal local step. CI/CD, deploy, release, and PR automation are out of scope.

## Evidence Invalidation

- Any relevant change after `VERIFY` invalidates `VERIFY` and `REVIEW` evidence.
- Any relevant change after `REVIEW` invalidates `REVIEW` evidence.
- Any requirement or eval change invalidates dependent verification evidence.
- Any structural change that contradicts design decisions should roll back to `DESIGN`.

## Rework Prevention Checklist

Before passing each gate, verify:

1. **Evidence is fresh**: Evidence was captured after the last relevant change
2. **Rollback is specific**: Target is a phase name, not "earlier" or "previous"
3. **State is aligned**: `state.md` and `state.json` agree on current phase and status
4. **Run history is current**: `run-history.json` records this phase transition

## Common Rework Triggers

| Phase | Common Rework Cause | Prevention |
| --- | --- | --- |
| SPECIFY | Vague requirements, missing scope | Use "SHALL" statements, explicit Out of Scope |
| DESIGN | Missing structure, unclear interfaces | Define decisions before moving to tasks |
| TASKS | Missing dependencies, wrong execution class | List dependencies explicitly, mark class correctly |
| EXECUTION CONTRACT | Scope not locked, done criteria vague | Define exact scope and test requirements |
| EXECUTE | Partial progress reported as complete | Use task-level done definitions |
| VERIFY | Stale evidence from before changes | Compare timestamps, re-run verification |
| REVIEW | Missing rollback, vague findings | Include specific phase in rollback, cite evidence |
| FINALIZE | Artifacts not synchronized, state drift | Check alignment before finalize gate |
