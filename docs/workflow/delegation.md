# Delegation

Delegation keeps the main agent focused and makes work restartable.

## When To Delegate

Delegate when:

- analysis is broader than a small local scope
- work can be isolated by area or task
- multiple independent tasks can proceed without shared-state conflicts
- the main agent would otherwise absorb raw context unnecessarily

## Minimum Context Contract

Every delegated task should include:

- objective
- relevant `REQ-*`
- relevant `EVAL-*`, when applicable
- allowed paths or areas
- required artifacts
- ready definition
- done definition
- dependencies

Avoid passing global context when task-local context is enough.

## Delegated Output Contract

Codebase readers and scoped executors should return only what the Orchestrator needs to decide the next step.

The standard output contract is:

- relevant files
- technical summary
- expected impact
- risks
- dependencies
- objective recommendations

## Block And Escalation Rules

- `blocked` means the task cannot safely continue inside its current scope.
- missing context is a form of `blocked` work and should explain exactly what input is missing.
- `escalate` means the workflow requires human judgment.

## Merge-Back Rules

- The Orchestrator merges conclusions, not raw transcripts.
- If delegated work changes the feature shape, update `state.*` and `run-history.*` before continuing.
- If delegated work invalidates evidence, mark stale evidence explicitly.

## Delegation Rework Triggers

Common delegation mistakes that cause rework:

| Mistake | Cause | Prevention |
| --- | --- | --- |
| Scope creep | Delegating with too much context | Keep context minimal and task-local |
| Wrong ownership | Task assigned to wrong role | Match owner to task type (e.g., Codebase Reader for analysis) |
| Missing dependencies | Task marked sequential but blocked | List dependencies explicitly in task definition |
| Vague objective | "fix X" instead of specific change | State exact objective with measurable done definition |
| Stale context | Delegating with outdated state | Verify state is current before delegating |
