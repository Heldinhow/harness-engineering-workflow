# Phases And Gates

Each phase defines entry assumptions, required evidence, an exit gate, and a rollback target.

| Phase | Entry assumptions | Purpose | Required evidence | Gate to exit | Rollback target on failure |
| --- | --- | --- | --- | --- | --- |
| INTAKE | a request or change target exists | define feature id, scope, complexity, owner | feature name or slug, complexity rationale | work is classified | INTAKE |
| SPECIFY | feature id and local goal are known | define the contract | `spec.md` with scope and `REQ-*` | requirements are clear and testable | SPECIFY |
| DESIGN | `spec.md` exists and structure matters | define structure when needed | `design.md` with decisions and mappings | structure is explicit enough to execute/review | DESIGN or SPECIFY |
| TASKS | `spec.md` exists and decomposition is needed | decompose work | `tasks.md` with deps and execution classes | work units are scoped and traceable | TASKS or DESIGN |
| EVAL DEFINE | requirements and risk areas are known | define proof | `eval.md` with `EVAL-*` and evidence method | behavior proof exists before meaningful change | EVAL DEFINE or SPECIFY |
| EXECUTE | planning artifacts are stable enough for scoped work | perform the work | task evidence, delegated results, updated state | tasks are complete or explicitly blocked | EXECUTE, TASKS, or DESIGN |
| VERIFY | execution produced a candidate implementation or artifact set | prove current status | fresh command or inspection evidence | current claim is proven now | EXECUTE |
| REVIEW | fresh verify evidence and current artifacts exist | decide readiness quality | `review.md` with findings and decision | decision is `pass`, `rework`, or `escalate` | VERIFY, EXECUTE, or DESIGN |
| REPORT | verify/review outcomes and current evidence exist | consolidate scope and evidence | `report.md` plus referenced evidence | delivery story is coherent and complete | VERIFY, REVIEW, or EXECUTE |
| FINISH | required gates are green and report is current | decide closure | all upstream gates are green | feature is ready to finalize | REVIEW, VERIFY, or REPORT |

## Gate Rules

### SPECIFY Gate
- Blocks execution when requirements are vague or contradictory.
- Must answer what is in scope and what is out of scope.

### EVAL DEFINE Gate
- Blocks meaningful behavior change until proof is defined.
- Must name at least one capability or regression eval for medium work and above.

### EXECUTE Gate
- Allows partial progress but not vague progress.
- Tasks must either be done, blocked with cause, or not started.

### VERIFY Gate
- Requires fresh evidence.
- Old evidence is stale after relevant changes.

### REVIEW Gate
- Uses only three decisions:
  - `pass`
  - `rework`
  - `escalate`
- `rework` stays inside the workflow.
- `escalate` requests human judgment and is a decision, not a workflow phase.

### REPORT Gate
- Must summarize delivered scope, verify evidence, eval evidence, review outcome, and residual risks.

## Evidence Invalidation

- Any relevant change after `VERIFY` invalidates `VERIFY`, `REVIEW`, and `REPORT` evidence.
- Any relevant change after `REVIEW` invalidates `REVIEW` and `REPORT` evidence.
- Any requirement or eval change invalidates dependent verification/report claims.
- Any structural change that contradicts design decisions should roll back to `DESIGN`.
