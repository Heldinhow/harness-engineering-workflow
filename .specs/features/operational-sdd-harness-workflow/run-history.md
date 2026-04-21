# Run History: operational-sdd-harness-workflow

## Runs

### RUN-001
- Phase: SPECIFY
- Transition: INTAKE->SPECIFY
- Status: passed
- Agent: orchestrator:main-session
- Related requirements: REQ-001, REQ-010
- Related evals: none
- Evidence refs:
  - `.specs/features/operational-sdd-harness-workflow/spec.md`
- Failure type: none
- Rollback target: none
- Decision: continue
- Notes: Captured scope, complexity, and the requirement set for the repository evolution.

### RUN-002
- Phase: DESIGN
- Transition: SPECIFY->DESIGN
- Status: passed
- Agent: design-agent:main-session
- Related requirements: REQ-003, REQ-005, REQ-006, REQ-008, REQ-009
- Related evals: none
- Evidence refs:
  - `.specs/features/operational-sdd-harness-workflow/design.md`
- Failure type: none
- Rollback target: SPECIFY
- Decision: continue
- Notes: Chose the Orchestrator-first model, paired state/history artifacts, and one review-specific skill.

### RUN-003
- Phase: TASKS
- Transition: DESIGN->TASKS
- Status: passed
- Agent: orchestrator:main-session
- Related requirements: REQ-004, REQ-010
- Related evals: none
- Evidence refs:
  - `.specs/features/operational-sdd-harness-workflow/tasks.md`
- Failure type: none
- Rollback target: DESIGN
- Decision: continue
- Notes: Split the implementation into contract docs, skills/templates, memory/examples, and final consistency work.

### RUN-004
- Phase: EVAL DEFINE
- Transition: TASKS->EVAL DEFINE
- Status: passed
- Agent: eval-agent:main-session
- Related requirements: REQ-002, REQ-006, REQ-007, REQ-008, REQ-009
- Related evals: EVAL-001, EVAL-002, EVAL-003, EVAL-004
- Evidence refs:
  - `.specs/features/operational-sdd-harness-workflow/eval.md`
- Failure type: none
- Rollback target: SPECIFY
- Decision: continue
- Notes: Defined capability and regression-style checks for the repository-wide workflow upgrade.

### RUN-005
- Phase: EXECUTE
- Transition: EVAL DEFINE->EXECUTE
- Status: passed
- Agent: orchestrator:main-session
- Related requirements: REQ-001, REQ-003, REQ-006, REQ-010
- Related evals: EVAL-001, EVAL-002
- Evidence refs:
  - `README.md`
  - `AGENTS.md`
  - `docs/workflow/overview.md`
  - `docs/workflow/phases-and-gates.md`
  - `docs/workflow/agent-roles.md`
  - `docs/workflow/delegation.md`
  - `docs/workflow/parallelism.md`
  - `docs/workflow/codebase-reading.md`
  - `docs/workflow/state-and-runs.md`
- Failure type: none
- Rollback target: DESIGN
- Decision: continue
- Notes: Rewrote the repository framing and phase/gate references.

### RUN-006
- Phase: EXECUTE
- Transition: EXECUTE->EXECUTE
- Status: passed
- Agent: execution-agent:parallel-lane-skills-templates
- Related requirements: REQ-001, REQ-002, REQ-004, REQ-005, REQ-006, REQ-007, REQ-008, REQ-009
- Related evals: EVAL-001, EVAL-002, EVAL-003
- Evidence refs:
  - `skills/harness-engineering-workflow/SKILL.md`
  - `skills/harness-planning/SKILL.md`
  - `skills/harness-execution/SKILL.md`
  - `skills/harness-evals/SKILL.md`
  - `skills/harness-review/SKILL.md`
  - `templates/`
  - `schemas/`
- Failure type: none
- Rollback target: TASKS
- Decision: continue
- Notes: Added the review skill and expanded templates and schemas to the new contract.

### RUN-007
- Phase: EXECUTE
- Transition: EXECUTE->EXECUTE
- Status: passed
- Agent: codebase-reader:parallel-lane-memory-examples
- Related requirements: REQ-010
- Related evals: EVAL-001, EVAL-004
- Evidence refs:
  - `memory/project/overview.md`
  - `memory/codebase/map.md`
  - `examples/small-feature/.specs/features/example-small/report.md`
  - `examples/medium-feature/.specs/features/example-medium/report.md`
- Failure type: none
- Rollback target: EXECUTE
- Decision: continue
- Notes: Added project/codebase memory and worked small/medium examples.

### RUN-008
- Phase: VERIFY
- Transition: EXECUTE->VERIFY
- Status: passed
- Agent: orchestrator:main-session
- Related requirements: REQ-006, REQ-008, REQ-009
- Related evals: EVAL-001, EVAL-002, EVAL-003, EVAL-004
- Evidence refs:
  - `command: git diff --check`
  - `command: state/run-history JSON validation`
- Failure type: none
- Rollback target: EXECUTE
- Decision: continue
- Notes: Structural verification passed before the first review pass.

### RUN-009
- Phase: REVIEW
- Transition: VERIFY->REVIEW
- Status: failed
- Agent: reviewer:external-review-pass-1
- Related requirements: REQ-005, REQ-006, REQ-007, REQ-008, REQ-009
- Related evals: EVAL-001, EVAL-002
- Evidence refs:
  - `docs/workflow/phases-and-gates.md`
  - `docs/workflow/codebase-reading.md`
  - `templates/report.md`
  - `.specs/features/operational-sdd-harness-workflow/state.md`
  - `.specs/features/operational-sdd-harness-workflow/run-history.md`
- Failure type: review_findings
- Rollback target: EXECUTE
- Decision: rework
- Notes: Review found invalid rollback vocabulary, an incomplete reader contract, a missing report rollback reminder, and stale feature-state artifacts.

### RUN-010
- Phase: VERIFY
- Transition: REVIEW->VERIFY
- Status: passed
- Agent: orchestrator:main-session
- Related requirements: REQ-005, REQ-006, REQ-007, REQ-008, REQ-009
- Related evals: EVAL-001, EVAL-002
- Evidence refs:
  - `command: git diff --check`
  - `command: state/run-history JSON validation`
  - `command: repo drift grep check`
- Failure type: none
- Rollback target: EXECUTE
- Decision: continue
- Notes: Applied the rework and refreshed verification evidence before the final review pass.

### RUN-011
- Phase: REVIEW
- Transition: VERIFY->REVIEW
- Status: passed
- Agent: reviewer:final-review-pass
- Related requirements: REQ-005, REQ-006, REQ-007, REQ-008, REQ-009, REQ-010
- Related evals: EVAL-001, EVAL-002, EVAL-003, EVAL-004
- Evidence refs:
  - `.specs/features/operational-sdd-harness-workflow/review.md`
- Failure type: none
- Rollback target: VERIFY
- Decision: continue
- Notes: Final review passed after the last contract and example fixes were applied.

### RUN-012
- Phase: REPORT
- Transition: REVIEW->REPORT
- Status: passed
- Agent: orchestrator:main-session
- Related requirements: REQ-006, REQ-007, REQ-008, REQ-009, REQ-010
- Related evals: EVAL-001, EVAL-002, EVAL-003, EVAL-004
- Evidence refs:
  - `.specs/features/operational-sdd-harness-workflow/report.md`
- Failure type: none
- Rollback target: REVIEW
- Decision: continue
- Notes: Consolidated the repository-wide workflow upgrade and its verification evidence into the final feature report.

### RUN-013
- Phase: FINISH
- Transition: REPORT->FINISH
- Status: passed
- Agent: orchestrator:main-session
- Related requirements: REQ-006, REQ-007, REQ-008, REQ-009, REQ-010
- Related evals: EVAL-001, EVAL-002, EVAL-003, EVAL-004
- Evidence refs:
  - `.specs/features/operational-sdd-harness-workflow/review.md`
  - `.specs/features/operational-sdd-harness-workflow/report.md`
- Failure type: none
- Rollback target: REVIEW
- Decision: finish
- Notes: Confirmed that review and report artifacts were current and closed the feature in `FINISH`.

### RUN-014
- Phase: VERIFY
- Transition: FINISH->VERIFY
- Status: passed
- Agent: orchestrator:main-session
- Related requirements: REQ-006, REQ-007, REQ-008, REQ-009
- Related evals: EVAL-002, EVAL-003, EVAL-004
- Evidence refs:
  - `command: git diff --check`
  - `command: state/run-history JSON validation`
  - `command: repo drift grep check`
- Failure type: none
- Rollback target: EXECUTE
- Decision: continue
- Notes: Refreshed verification after aligning report decision vocabulary to the repository standard.

### RUN-015
- Phase: REVIEW
- Transition: VERIFY->REVIEW
- Status: passed
- Agent: reviewer:final-closeout-review
- Related requirements: REQ-006, REQ-007, REQ-008, REQ-009, REQ-010
- Related evals: EVAL-001, EVAL-002, EVAL-003, EVAL-004
- Evidence refs:
  - `.specs/features/operational-sdd-harness-workflow/review.md`
- Failure type: none
- Rollback target: VERIFY
- Decision: continue
- Notes: Final standards review confirmed no remaining findings after the report vocabulary alignment.

### RUN-016
- Phase: REPORT
- Transition: REVIEW->REPORT
- Status: passed
- Agent: orchestrator:main-session
- Related requirements: REQ-006, REQ-007, REQ-008, REQ-009, REQ-010
- Related evals: EVAL-001, EVAL-002, EVAL-003, EVAL-004
- Evidence refs:
  - `.specs/features/operational-sdd-harness-workflow/report.md`
- Failure type: none
- Rollback target: REVIEW
- Decision: continue
- Notes: Refreshed the feature report after the final closeout review.

### RUN-017
- Phase: FINISH
- Transition: REPORT->FINISH
- Status: passed
- Agent: orchestrator:main-session
- Related requirements: REQ-006, REQ-007, REQ-008, REQ-009, REQ-010
- Related evals: EVAL-001, EVAL-002, EVAL-003, EVAL-004
- Evidence refs:
  - `.specs/features/operational-sdd-harness-workflow/review.md`
  - `.specs/features/operational-sdd-harness-workflow/report.md`
- Failure type: none
- Rollback target: REVIEW
- Decision: finish
- Notes: Confirmed the refreshed review/report evidence and closed the feature again in `FINISH`.
