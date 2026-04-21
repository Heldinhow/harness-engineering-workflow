---
name: harness-evals
description: Use when a feature needs explicit capability or regression evals before completion, with lightweight definitions for small work and stronger evidence for larger or riskier changes.
---

# Harness Evals

This skill owns the quality and evidence layer.

It keeps eval-driven development lightweight but non-optional for meaningful work.

## Eval Types

### Capability Evals
Use for new behavior.
Question answered: can the system now do what it could not do before?

### Regression Evals
Use for existing behavior that must still work.
Question answered: did this change preserve what already worked?

## Eval Definition Rules

Create `.specs/features/<feature>/eval.md` before meaningful implementation.

That file should include:
- capability evals
- regression evals
- thresholds when relevant
- notes about graders or assumptions

## Strength by Complexity

### Small
A lightweight eval definition is enough.
At minimum, name the new behavior and the regression risk.

### Medium
Define at least one concrete capability or regression eval.
Tie each eval back to a requirement ID where possible.

### Large / Complex
Use both capability and regression evals.
For critical paths, use stronger repeatability expectations such as pass@k or pass^k.

## Reporting

The final feature report should summarize:
- which capability evals passed
- which regression evals passed
- any threshold used
- whether the feature is ready, needs rework, or needs human review

## Eval Failure Loops

- Behavior fails eval → back to Execute
- Eval criteria are vague, incomplete, or wrong → back to Eval Define
- Requirement itself is unclear → back to Specify

## Preference Order

Prefer deterministic evidence when possible.
Use broader or human judgment only when deterministic checks are insufficient.
