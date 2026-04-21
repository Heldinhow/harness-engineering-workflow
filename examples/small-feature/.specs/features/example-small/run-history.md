# Run History: example-small

## Runs

### RUN-001
- Phase: SPECIFY
- Transition: INTAKE->SPECIFY
- Status: passed
- Agent: orchestrator:example-session-small
- Related requirements: REQ-001, REQ-010
- Related evals: none
- Evidence refs:
  - `.specs/features/example-small/spec.md`
- Failure type: none
- Rollback target: none
- Decision: continue
- Notes: Classified the feature as small and documented a local report-template scenario.

### RUN-002
- Phase: EVAL DEFINE
- Transition: SPECIFY->EVAL DEFINE
- Status: passed
- Agent: eval-agent:example-session-small
- Related requirements: REQ-002
- Related evals: EVAL-001, EVAL-002
- Evidence refs:
  - `.specs/features/example-small/eval.md`
- Failure type: none
- Rollback target: none
- Decision: continue
- Notes: Defined one capability eval for the rollback reminder and one regression eval for the lightweight artifact set.

### RUN-003
- Phase: EXECUTE
- Transition: EVAL DEFINE->EXECUTE
- Status: passed
- Agent: execution-agent:example-session-small
- Related requirements: REQ-006
- Related evals: EVAL-001
- Evidence refs:
  - `templates/report.md`
- Failure type: none
- Rollback target: none
- Decision: continue
- Notes: Applied the local template change without expanding the scope into design or tasks.

### RUN-004
- Phase: VERIFY
- Transition: EXECUTE->VERIFY
- Status: passed
- Agent: orchestrator:example-session-small
- Related requirements: REQ-006, REQ-008, REQ-009
- Related evals: EVAL-001, EVAL-002
- Evidence refs:
  - `templates/report.md`
  - `.specs/features/example-small/state.json`
  - `.specs/features/example-small/run-history.json`
- Failure type: none
- Rollback target: EXECUTE
- Decision: continue
- Notes: Confirmed fresh evidence and aligned state/run artifacts.

### RUN-005
- Phase: REVIEW
- Transition: VERIFY->REVIEW
- Status: passed
- Agent: reviewer:example-session-small
- Related requirements: REQ-006, REQ-010
- Related evals: EVAL-001, EVAL-002
- Evidence refs:
  - `.specs/features/example-small/review.md`
- Failure type: none
- Rollback target: VERIFY
- Decision: continue
- Notes: Formal review passed with no findings.

### RUN-006
- Phase: REPORT
- Transition: REVIEW->REPORT
- Status: passed
- Agent: orchestrator:example-session-small
- Related requirements: REQ-008, REQ-009, REQ-010
- Related evals: EVAL-001, EVAL-002
- Evidence refs:
  - `.specs/features/example-small/report.md`
- Failure type: none
- Rollback target: REVIEW
- Decision: continue
- Notes: Consolidated the small feature into a final report and prepared the working set for the finish gate.

### RUN-007
- Phase: FINISH
- Transition: REPORT->FINISH
- Status: passed
- Agent: orchestrator:example-session-small
- Related requirements: REQ-008, REQ-009, REQ-010
- Related evals: EVAL-001, EVAL-002
- Evidence refs:
  - `.specs/features/example-small/review.md`
  - `.specs/features/example-small/report.md`
- Failure type: none
- Rollback target: REVIEW
- Decision: finish
- Notes: Confirmed that review and report evidence were current and closed the small example in `FINISH`.
