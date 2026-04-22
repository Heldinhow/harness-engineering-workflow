# Parallelism

Parallelism is allowed when it is explicit, bounded, and safe.

## Execution Classes

Each task must be marked as one of:

- `sequential`: depends on another task, mutates shared critical state, or touches the same core artifact lane.
- `parallelizable`: can proceed independently and safely merge back later.
- `blocked`: cannot proceed until a dependency, gate, or human decision is resolved.

## Fan-Out Rules

The Orchestrator may fan out work only after:

- `spec.md` is stable enough
- `design.md` exists when structure matters
- `eval.md` is defined for meaningful behavior changes
- task boundaries and ownership are explicit

## Fan-In Rules

The Orchestrator must fan in before:

- `VERIFY`
- `REVIEW`
- `FINALIZE`

Fan-in means:

- dependency status is resolved
- conflicting edits are reconciled
- task evidence is collected
- state and run history are updated

## Good Candidates For Parallel Lanes

- codebase reading for distinct areas
- impact analysis for separate modules
- examples and memory docs after the workflow contract is stable
- independent template or skill updates with a later consolidation pass

## Bad Candidates For Parallel Lanes

- two lanes editing the same artifact without a defined merge plan
- work that depends on unresolved vocabulary or gate decisions
- verification, review, and reporting before fan-in

## Parallel Rework Triggers

| Issue | Cause | Prevention |
| --- | --- | --- |
| Merge conflicts | Parallel lanes editing same files | Define ownership boundaries |
| Inconsistent state | Lanes updating state differently | Consolidate state updates at fan-in |
| Stale evidence from wrong lane | Evidence captured before merge | Re-verify after merge |
| Missing fan-in | Skipping consolidation | Always fan-in before VERIFY |
| Dependency not resolved | Tasks marked parallelizable but blocked | Verify dependencies at fan-in |
