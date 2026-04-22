# Run History: example-medium

## Runs

### RUN-001 — SPECIFY
Transition: INTAKE→SPECIFY | Status: passed | Agent: orchestrator
Notes: Classified the feature as medium. eval.md was created during SPECIFY (EVAL DEFINE is no longer a separate phase).

### RUN-002 — DESIGN
Transition: SPECIFY→DESIGN | Status: passed | Agent: design-agent
Notes: Chose one delegated analysis lane and two execution lanes with required fan-in before verify.

### RUN-003 — TASKS
Transition: DESIGN→TASKS | Status: passed | Agent: orchestrator
Notes: Finalized task boundaries, dependencies, execution classes, and eval coverage.

### RUN-004 — EXECUTION CONTRACT
Transition: TASKS→EXECUTION CONTRACT | Status: passed | Agent: orchestrator
Notes: Locked the run scope, included and excluded tasks, parallelism class, expected surfaces, mandatory tests, and rollback routing before fan-out.

### RUN-005 — EXECUTE (TASK-001: delegated read)
Transition: EXECUTION CONTRACT→EXECUTE | Status: passed | Agent: codebase-reader
Notes: Completed the delegated read and returned a bounded report.

### RUN-006 — EXECUTE (TASK-002, TASK-003: parallel lanes)
Transition: EXECUTE→EXECUTE | Status: passed | Agent: implementer
Notes: Completed both execution lanes and updated example artifacts before first verify pass.

### RUN-007 — VERIFY
Transition: EXECUTE→VERIFY | Status: passed | Agent: orchestrator
Notes: Captured the first verify pass before a late fan-in wording fix changed run-history.json.

### RUN-008 — REVIEW (rework loop)
Transition: VERIFY→REVIEW | Status: failed | Agent: reviewer | Decision: rework
Notes: Review found that a late fan-in edit to run-history.json invalidated RUN-007 evidence. Rolled back to VERIFY.

### RUN-009 — VERIFY (after rework)
Transition: REVIEW→VERIFY | Status: passed | Agent: orchestrator
Notes: Refreshed verify evidence after fan-in and cleared stale evidence references.

### RUN-010 — REVIEW
Transition: VERIFY→REVIEW | Status: passed | Agent: reviewer
Notes: Review passed after confirming verify evidence was fresh and the rework loop was captured.

### RUN-011 — FINALIZE
Transition: REVIEW→FINALIZE | Status: passed | Agent: orchestrator | Decision: finish
Notes: Confirmed review evidence was current and closed the medium example in FINALIZE. This replaces the old REPORT+FINISH split.
