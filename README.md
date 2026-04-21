# Harness Engineering Workflow

A compact skill package for harness engineering that consolidates ideas from three source workflows into one practical package:

- **TLC Spec-Driven** as the planning model for scoping, feature artifacts, and adaptive depth
- **Superpowers** as the execution discipline model for TDD, verification, review, and finish behavior
- **eval-harness** as the evidence model for capability and regression checks

These source workflows are **not required as separate dependencies in this repository**.
This repository ships its own consolidated skills that absorb the relevant behavior in a smaller package.

This repository packages the consolidated workflow as four reusable skills plus a small template set.

---

## Repository Structure

```text
README.md
skills/
  harness-engineering-workflow/
    SKILL.md
  harness-planning/
    SKILL.md
  harness-execution/
    SKILL.md
  harness-evals/
    SKILL.md
templates/
  spec.md
  design.md
  tasks.md
  eval.md
  state.md
  report.md
```

---

## What This Package Is

This is a **workflow package**, not a large framework runtime.

It is designed to be:
- small enough to adopt quickly
- structured enough to prevent sloppy execution
- explicit enough to support rework loops and evidence-based completion
- flexible enough for small and medium changes without too much ceremony

It does **not** require specialized agents.
The workflow is implemented as a small set of skills with clear responsibilities.

---

## Installed Skills

### 1. `harness-engineering-workflow`
The primary workflow skill.

Responsibilities:
- define the full workflow
- decide which phases apply
- apply sizing rules
- define loop-back behavior
- route work to planning, execution, and eval skills

Use this when you want the whole process.

### 2. `harness-planning`
The planning layer.

Responsibilities:
- create `spec.md`
- create `design.md` when needed
- create `tasks.md` when needed
- maintain `state.md`
- keep requirements traceable with IDs

This is where the TLC influence is strongest.

### 3. `harness-execution`
The execution layer.

Responsibilities:
- implement against approved planning artifacts
- enforce TDD for behavior changes
- require fresh verification before completion claims
- loop back instead of improvising missing scope

This is where the Superpowers influence is strongest.

### 4. `harness-evals`
The evidence layer.

Responsibilities:
- define capability evals
- define regression evals
- scale eval rigor by complexity
- contribute final evidence to the report

This is where the eval-harness influence is strongest.

---

## Unified Workflow

The package uses this end-to-end flow:

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

This flow is intentionally simple.
It is meant to be followed consistently, not interpreted differently every time.

---

## Phase-by-Phase Explanation

## 1. Intake

Purpose:
- identify the feature or change
- define the local goal
- choose a complexity level

Typical outcome:
- a feature name or slug
- a sense of whether the change is Small, Medium, Large, or Complex

For very small work, Intake may be brief, but it should still happen.

---

## 2. Specify

Purpose:
- define what the change is supposed to achieve
- create a minimum shared contract before implementation

Artifact:
- `spec.md`

A good spec should include:
- objective
- in-scope and out-of-scope items
- requirement IDs like `REQ-001`
- acceptance criteria in behavioral language

Why this matters:
- prevents premature coding
- gives review and evals something concrete to check against

---

## 3. Design

Purpose:
- explain how the solution should work when structure matters

Artifact:
- `design.md`

Design is needed when:
- multiple components are involved
- interfaces matter
- integrations matter
- there are trade-offs to resolve
- review would otherwise be guesswork

Design can be skipped for clearly local Small changes.

---

## 4. Tasks

Purpose:
- decompose execution into trackable pieces when needed

Artifact:
- `tasks.md`

Tasks are useful when:
- multiple steps are needed
- sequence matters
- several files are touched
- progress would otherwise be vague

Tasks can be skipped when a Small change fits a single short TDD cycle.

---

## 5. Eval Define

Purpose:
- define how success will be checked before completion

Artifact:
- `eval.md`

The eval file should describe:
- new behavior that must work (capability evals)
- existing behavior that must still work (regression evals)
- thresholds when relevant
- assumptions about grading or evidence

Why this matters:
- avoids vague “looks good” completion
- forces explicit proof expectations before finalization

---

## 6. Execute

Purpose:
- implement the change using the approved planning artifacts

Execution rules:
- follow the spec
- use the design when present
- follow tasks when present
- do not improvise scope
- use TDD for feature work, bugfixes, and behavior changes

Superpowers influence here:
- strict implementation discipline
- avoid undisciplined coding
- prefer isolation on Medium+ work when practical

---

## 7. Verify

Purpose:
- prove the implementation currently works

This is not the same thing as “I think it is done.”

Verification means:
- identify the command that proves the claim
- run that command now
- inspect the actual output
- report the result based on evidence

This phase directly carries the `verification-before-completion` philosophy.

---

## 8. Review

Purpose:
- compare what was built against what was intended
- ensure the solution is not obviously out of bounds or structurally wrong

Review should check:
- does implementation match the spec?
- was anything clearly out-of-scope added?
- is the structure reasonable for the intended change?
- are open issues explicit?

This is lighter than a heavyweight formal review system, but it is still a gate.

---

## 9. Report

Purpose:
- summarize what was delivered and what evidence exists

Artifact:
- `report.md`

The report should include:
- summary of scope delivered
- verification evidence
- review result
- eval result
- final recommendation: ready, rework, or blocked

---

## 10. Finish

Purpose:
- decide whether the work is actually ready to be finalized

Before finish, confirm:
- applicable planning artifacts exist
- evals were defined before meaningful implementation
- verification evidence is fresh
- review was completed
- report was written

This phase corresponds to the final branch/PR readiness decision.

---

## Where Each Source Enters the Workflow

## TLC Spec-Driven

TLC is the base of the **planning layer**.

It contributes:
- explicit artifacts per feature
- requirement IDs
- persistent feature state
- adaptive depth by complexity

In this package, that influence is concentrated in:
- `skills/harness-planning/`
- `templates/spec.md`
- `templates/design.md`
- `templates/tasks.md`
- `templates/state.md`

## Superpowers

Superpowers is the base of the **execution discipline layer**.

It contributes:
- skill-first discipline
- TDD for behavior changes
- evidence before completion
- execution against a plan
- practical isolation guidance for larger work
- review/finish mindset

In this package, that influence is strongest in:
- `skills/harness-execution/`
- Verify, Review, and Finish behavior in the main workflow

## eval-harness

eval-harness is the base of the **quality and evidence layer**.

It contributes:
- capability evals
- regression evals
- pass/fail thinking before finalization
- thresholds for stronger cases

In this package, that influence is concentrated in:
- `skills/harness-evals/`
- `templates/eval.md`
- `templates/report.md`

---

## Sizing Rules

## Small
Use the lightweight path when the work is local and obvious.

Expected:
- `spec.md` required
- `design.md` optional
- `tasks.md` optional
- `eval.md` lightweight
- review still required

## Medium
Use the standard path for multi-file or moderately risky changes.

Expected:
- `spec.md` required
- `design.md` recommended
- `tasks.md` required
- `eval.md` required
- review required

## Large / Complex
Use the full path.

Expected:
- `spec.md` required
- `design.md` required
- `tasks.md` required
- capability and regression evals required
- explicit rework loops required

---

## Loop-Back Rules

When a gate fails, do not improvise. Go back to the right phase.

- Verify fails → go back to Execute
- Review fails because implementation is incomplete → go back to Execute
- Review fails because structure is wrong → go back to Design
- Eval fails because behavior is wrong → go back to Execute
- Eval fails because criteria are weak or unclear → go back to Eval Define
- Spec is unclear or conflicting → go back to Specify

This is one of the most important properties of the workflow.

---

## Feature Files

For each feature, the recommended working set is:

```text
.specs/features/<feature>/
  spec.md
  design.md        # when needed
  tasks.md         # when needed
  eval.md
  state.md
  report.md
```

### `state.md`
This is the minimal persistent memory for the feature.

It should record:
- current phase
- status
- complexity
- open issues
- latest evidence
- next step
- loop rule

---

## Typical Usage

A normal feature might be handled like this:

1. Use `harness-engineering-workflow`
2. Create `spec.md`
3. Create `design.md` if the structure matters
4. Create `tasks.md` if decomposition is needed
5. Create `eval.md`
6. Implement using `harness-execution`
7. Verify using fresh command output
8. Review against the plan
9. Write `report.md`
10. Finalize only if all required evidence exists

---

## Example: Medium Feature

Suppose you want to add a new harness report mode.

A good path would be:

1. **Specify**
   - define what the new report mode does
   - add `REQ-001`, `REQ-002`

2. **Design**
   - explain where the new mode plugs into the existing flow
   - describe any formatter or output decisions

3. **Tasks**
   - split implementation into parser/update/report steps

4. **Eval Define**
   - define one capability eval for the new mode
   - define one regression eval for existing report output

5. **Execute**
   - implement using TDD for the new behavior

6. **Verify**
   - run commands proving the new mode works

7. **Review**
   - compare delivered behavior to the spec/design

8. **Report**
   - summarize what shipped and what passed

9. **Finish**
   - only then treat it as ready

---

## Suggested Commands / Triggers

These phrases map well to the package:

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

---

## How to Install / Reuse

If you want to reuse this package in another environment:

1. Copy the `skills/` directory into your skills workspace
2. Copy the `templates/` directory into your preferred project scaffolding location
3. Start with `harness-engineering-workflow`
4. Use the companion skills as directed by the workflow

---

## Why This Package Exists

The goal is to avoid both extremes:

- **too loose**: coding without spec, eval, or evidence
- **too heavy**: turning every change into a giant planning ceremony

This package keeps the workflow:
- explicit
- composable
- evidence-based
- practical for real work

---

## Summary

This repository gives you a compact, reusable workflow package for harness engineering with:
- 1 main workflow skill
- 3 focused companion skills
- 6 minimal templates
- clear loops for rework
- explicit planning, execution, and evidence phases

If you want to extend it later, the most natural next additions would be:
- a dedicated review skill
- a dedicated finish skill
- stricter eval templates for release-critical work
