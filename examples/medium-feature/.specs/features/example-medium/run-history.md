# Run History: example-medium

## Runs

### RUN-001
- Phase: SPECIFY
- Transition: INTAKE->SPECIFY
- Status: passed
- Agent: orchestrator:example-session-medium
- Related requirements: REQ-001, REQ-010
- Related evals: none
- Evidence refs:
  - `.specs/features/example-medium/spec.md`
- Failure type: none
- Rollback target: none
- Decision: continue
- Notes: Classified the feature as medium because it spans delegated analysis, task decomposition, and a review loop.

### RUN-002
- Phase: DESIGN
- Transition: SPECIFY->DESIGN
- Status: passed
- Agent: design-agent:example-session-medium
- Related requirements: REQ-004, REQ-010
- Related evals: none
- Evidence refs:
  - `.specs/features/example-medium/design.md`
- Failure type: none
- Rollback target: SPECIFY
- Decision: continue
- Notes: Chose one delegated analysis lane and two execution lanes with required fan-in before verify.

### RUN-003
- Phase: TASKS
- Transition: DESIGN->TASKS
- Status: passed
- Agent: orchestrator:example-session-medium
- Related requirements: REQ-004
- Related evals: EVAL-002
- Evidence refs:
  - `.specs/features/example-medium/tasks.md`
  - `.specs/features/example-medium/eval.md`
- Failure type: none
- Rollback target: DESIGN
- Decision: continue
- Notes: Finalized task boundaries, dependencies, execution classes, and eval coverage before execution.

### RUN-004
- Phase: EXECUTE
- Transition: TASKS->EXECUTE
- Status: passed
- Agent: codebase-reader:example-reader-01
- Related requirements: REQ-005, REQ-010
- Related evals: EVAL-001, EVAL-003
- Evidence refs:
  - `.specs/features/example-medium/delegation.md`
  - `.specs/features/example-medium/codebase-reader-report.md`
- Failure type: none
- Rollback target: TASKS
- Decision: continue
- Notes: Completed the delegated read and returned a bounded report for state/run-history planning.

### RUN-005
- Phase: EXECUTE
- Transition: EXECUTE->EXECUTE
- Status: passed
- Agent: execution-agent:fanin-lanes
- Related requirements: REQ-004, REQ-006, REQ-008, REQ-009
- Related evals: EVAL-001, EVAL-002
- Evidence refs:
  - `.specs/features/example-medium/state.md`
  - `.specs/features/example-medium/state.json`
  - `.specs/features/example-medium/run-history.md`
  - `.specs/features/example-medium/run-history.json`
- Failure type: none
- Rollback target: EXECUTE
- Decision: continue
- Notes: Completed both execution lanes and updated the example artifacts before the first verify pass.

### RUN-006
- Phase: VERIFY
- Transition: EXECUTE->VERIFY
- Status: passed
- Agent: orchestrator:example-session-medium
- Related requirements: REQ-006, REQ-008, REQ-009
- Related evals: EVAL-001, EVAL-002
- Evidence refs:
  - `.specs/features/example-medium/state.json`
  - `.specs/features/example-medium/run-history.json`
- Failure type: none
- Rollback target: EXECUTE
- Decision: continue
- Notes: Captured the first verify pass before a late fan-in wording fix changed `run-history.json`.

### RUN-007
- Phase: REVIEW
- Transition: VERIFY->REVIEW
- Status: failed
- Agent: reviewer:example-session-medium
- Related requirements: REQ-006, REQ-007, REQ-009
- Related evals: EVAL-001, EVAL-002
- Evidence refs:
  - `.specs/features/example-medium/run-history.json`
  - `.specs/features/example-medium/state.json`
- Failure type: stale_evidence
- Rollback target: VERIFY
- Decision: rework
- Notes: Review found that a late fan-in edit to `run-history.json` invalidated RUN-006, so the workflow rolled back to VERIFY.

### RUN-008
- Phase: VERIFY
- Transition: REVIEW->VERIFY
- Status: passed
- Agent: orchestrator:example-session-medium
- Related requirements: REQ-006, REQ-008, REQ-009
- Related evals: EVAL-001, EVAL-002
- Evidence refs:
  - `.specs/features/example-medium/state.json`
  - `.specs/features/example-medium/run-history.json`
  - `.specs/features/example-medium/run-history.md`
- Failure type: none
- Rollback target: EXECUTE
- Decision: continue
- Notes: Refreshed verify evidence after fan-in and cleared the stale evidence references.

### RUN-009
- Phase: REVIEW
- Transition: VERIFY->REVIEW
- Status: passed
- Agent: reviewer:example-session-medium
- Related requirements: REQ-006, REQ-007, REQ-010
- Related evals: EVAL-001, EVAL-002, EVAL-003
- Evidence refs:
  - `.specs/features/example-medium/review.md`
- Failure type: none
- Rollback target: VERIFY
- Decision: continue
- Notes: Review passed after confirming that verify evidence was fresh and the rework loop was captured.

### RUN-010
- Phase: REPORT
- Transition: REVIEW->REPORT
- Status: passed
- Agent: orchestrator:example-session-medium
- Related requirements: REQ-008, REQ-009, REQ-010
- Related evals: EVAL-001, EVAL-002, EVAL-003
- Evidence refs:
  - `.specs/features/example-medium/report.md`
- Failure type: none
- Rollback target: REVIEW
- Decision: continue
- Notes: Consolidated the delegated analysis, rework loop, and final readiness into the medium example report.

### RUN-011
- Phase: FINISH
- Transition: REPORT->FINISH
- Status: passed
- Agent: orchestrator:example-session-medium
- Related requirements: REQ-008, REQ-009, REQ-010
- Related evals: EVAL-001, EVAL-002, EVAL-003
- Evidence refs:
  - `.specs/features/example-medium/review.md`
  - `.specs/features/example-medium/report.md`
- Failure type: none
- Rollback target: REVIEW
- Decision: finish
- Notes: Confirmed the review/report evidence was current and closed the medium example in `FINISH`.
