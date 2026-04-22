# Design

## Purpose

Define structure, interfaces, data flow, and key decisions when they affect execution or review.

## Entry Assumptions

- `spec.md` exists and structure, interfaces, or trade-offs matter.

## Exit Gate

- `design.md` exists with decisions and mappings that are explicit enough to execute and review against.

## When DESIGN Is Required

Create `design.md` when any of these are true:

- the change spans multiple components or modules
- an interface, integration, or data flow needs to be recorded
- there are meaningful trade-offs that affect implementation choices
- review would otherwise rely on guesswork or assumption

## When DESIGN Can Be Skipped

- Clearly local small changes where structure is already obvious.
- If in doubt, create it — the cost is low and the clarity is high.

## What to Produce

`design.md` should define:

- **Summary**: the chosen approach
- **Existing Context / Reuse**: what is being reused from the codebase
- **DES-***: key decisions with rationale
- **Requirement Mapping**: how each REQ-* maps to artifacts, flows, or decisions
- **Risks**: identified risks with their mitigations

## Rollback

- Structural inconsistency or missing decisions → DESIGN
- Ambiguity that surfaces during design → SPECIFY

## Design Quality Checklist

Before passing the DESIGN gate, verify:

1. **Decisions are explicit**: each DES-* states the decision and why
2. **Requirements are mapped**: every REQ-* has a traceable design artifact
3. **Risks are identified**: risks that could block execution are surfaced
4. **Mitigations are recorded**: for each identified risk
5. **Structure is clear enough to execute**: no guesswork needed at TASKS or EXECUTE
