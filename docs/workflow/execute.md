# Execute

## Purpose

Implement the work per task, following the execution contract and producing traceable evidence.

## Entry Assumptions

- `spec.md`, `design.md` (if applicable), `tasks.md`, and `execution-contract.md` are stable.
- The Orchestrator has delegated scoped work.

## Exit Gate

- Implementation is complete or explicitly blocked.
- Evidence is captured for each task.
- State and run history are updated.

## Execution Rules

- Execute per task, not as one undifferentiated change.
- Follow the current `spec.md`, `design.md`, `tasks.md`, and `execution-contract.md`.
- Delegate only the local context needed for the scoped task.
- Mark work as complete, blocked, or not started. Do not report vague progress.

## Minimal Context Principle

Each task execution should receive only:

- the task objective
- relevant REQ-*
- relevant EVAL-* when applicable
- allowed paths
- dependencies
- ready definition
- done definition

If execution reveals missing scope, unclear requirements, or broken task boundaries, stop and roll back instead of inventing new contract.

## Evidence Capture

Before marking a task done:

1. Identify the command or inspection that proves completion
2. Run it now
3. Inspect the actual output
4. Record the evidence reference

## State and Run History

After each meaningful step:

- Update `state.md` and `state.json` together
- Record the transition in `run-history.md` and `run-history.json`

## Rollback

- Implementation issue or failing proof → EXECUTE
- Requirement ambiguity → SPECIFY
- Structural inconsistency → DESIGN
- Bad decomposition → TASKS

## Execute Quality Checklist

Before passing the EXECUTE gate, verify:

1. **Tasks are complete or blocked**: no vague progress
2. **Evidence is captured**: command output or inspection for each task
3. **State is aligned**: state.md and state.json agree
4. **Run history is updated**: this phase transition is recorded
5. **No scope drift**: work matches the execution contract
