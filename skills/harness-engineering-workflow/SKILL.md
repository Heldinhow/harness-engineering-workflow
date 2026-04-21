---
name: harness-engineering-workflow
description: Use when a task needs a unified harness engineering workflow with minimal planning artifacts, disciplined execution, explicit rework loops, and eval-based evidence before final completion.
---

# Harness Engineering Workflow

A compact workflow for harness engineering with minimal planning artifacts, disciplined execution, explicit rework loops, and eval-based evidence before final completion.

Use this as the primary workflow skill. It decides the path and hands off to the planning, execution, and eval skills.

## Core Flow

```text
INTAKE
→ SPECIFY
→ DESIGN
→ TASKS
→ EVAL DEFINE
→ EXECUTE
→ VERIFY
→ REVIEW
→ REPORT
→ FINISH
```

## What Each Phase Produces

| Phase | Output |
|------|--------|
| Intake | feature name, scope, complexity |
| Specify | `.specs/features/<feature>/spec.md` |
| Design | `.specs/features/<feature>/design.md` when needed |
| Tasks | `.specs/features/<feature>/tasks.md` when needed |
| Eval Define | `.specs/features/<feature>/eval.md` |
| Execute | code + tests + implementation evidence |
| Verify | fresh command output proving current status |
| Review | brief review notes against spec and quality |
| Report | `.specs/features/<feature>/report.md` |
| Finish | branch/PR/local completion decision |

## Required Rules

1. Never implement before minimal spec exists.
2. Never change behavior before defining applicable evals.
3. Use TDD for feature work, bugfixes, and behavior changes.
4. Never claim completion without fresh verification evidence.
5. Review before finishing.
6. If a gate fails, loop back explicitly instead of improvising.

## Sizing

### Small
Use the light path when the change is local and obvious.
- `spec.md`: required
- `design.md`: optional
- `tasks.md`: optional
- `eval.md`: lightweight
- review: still required

### Medium
Use the standard path for multi-file or moderately risky changes.
- `spec.md`: required
- `design.md`: recommended
- `tasks.md`: required
- `eval.md`: required
- review: required

### Large / Complex
Use the full path.
- `spec.md`: required
- `design.md`: required
- `tasks.md`: required
- capability + regression evals: required
- explicit review and rework loops: required

## Loop Rules

- Verify fails → go back to Execute
- Review fails due to implementation gap → go back to Execute
- Review fails due to structural/design issue → go back to Design
- Eval fails due to behavior → go back to Execute
- Eval fails due to bad or missing criteria → go back to Eval Define
- Spec is unclear or conflicting → go back to Specify

## Skill Routing

Use these companion skills during the workflow:
- **REQUIRED SUB-SKILL:** `harness-planning` for Specify, Design, and Tasks
- **REQUIRED SUB-SKILL:** `harness-execution` for Execute and Verify discipline
- **REQUIRED SUB-SKILL:** `harness-evals` for Eval Define and evidence reporting

## State File

Use one feature state file as the workflow memory source of truth:
- `.specs/features/<feature>/state.md`

Keep it simple:
- current phase
- current status
- complexity
- open issues
- latest evidence
- next step
- loop-back rule

## Commands / Triggers

- `initialize project`
- `specify feature <name>`
- `design feature <name>`
- `plan tasks <name>`
- `define evals <name>`
- `execute feature <name>`
- `verify feature <name>`
- `review feature <name>`
- `report feature <name>`
- `resume feature <name>`
- `finalize feature <name>`

## Finish Criteria

Before finishing, confirm all applicable conditions are true:
- spec exists and matches delivered scope
- evals were defined before meaningful implementation
- verification evidence is fresh
- review completed
- report written

If any of these are missing, the work is not ready to finish.
