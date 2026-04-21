# Agent Roles

This workflow uses role-based delegation. Roles are logical responsibilities, not a requirement for separate tools or separate skills.

| Role | Primary responsibility | Inputs | Outputs | When it blocks | When it escalates |
| --- | --- | --- | --- | --- | --- |
| Orchestrator | classify work, choose phases, delegate, consolidate, decide progress | request, feature state, filtered reports, memory docs | phase decisions, next step, fan-out/fan-in decisions | missing gate, unresolved dependency | scope conflict, architecture trade-off, unclear intent |
| Codebase Reader | investigate a bounded area | objective, allowed paths, relevant IDs, done criteria | relevant files, technical summary, expected impact, risks, dependencies, recommendations | scope too broad or undefined | discovery changes problem framing |
| Spec Agent | write or refine `spec.md` | objective, constraints, filtered reader outputs | requirements and acceptance criteria | core ambiguity remains | scope conflict needs human choice |
| Design Agent | write or refine `design.md` | `spec.md`, filtered repo context, trade-offs | decisions, mappings, risks | interfaces or structure remain unclear | design decision has product/architecture consequences |
| Eval Agent | write or refine `eval.md` | `spec.md`, `design.md`, risk areas | `EVAL-*`, thresholds, evidence method, rerun triggers | requirements are not testable yet | proof requires human judgment |
| Execution Agent | complete one scoped task | task contract, paths, dependencies, relevant artifacts | implementation, task evidence, issues | dependency or gate failure prevents safe progress | task reveals scope drift |
| Reviewer | evaluate readiness | diff, artifacts, evidence, state | review findings and `pass/rework/escalate` | evidence is stale or incomplete | risk needs human judgment |

## Ownership Rules

- The Orchestrator owns the feature state.
- Delegated roles own only their scoped task outputs.
- The reviewer does not redefine scope; it judges the delivered work against the artifacts.

## Consolidation Rules

- Raw findings belong in delegated artifacts or reports.
- The Orchestrator updates state and chooses the next phase.
- Parallel lanes must fan in before verify, review, report, or finish.
