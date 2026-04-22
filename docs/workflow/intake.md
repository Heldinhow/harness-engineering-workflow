# Intake

## Purpose

Classify the incoming request: scope, complexity, ambiguity level, and what phases are actually needed.

## Entry Assumptions

- A request or change target exists.

## Exit Gate

- Feature id, scope, complexity, and owner are defined.
- The Orchestrator has decided which phases apply.

## What to Classify

### Complexity
- **small**: local and obvious change, no design needed, single short execution loop
- **medium**: multi-file or moderately risky change, design recommended, tasks needed
- **large / complex**: cross-cutting, integration-heavy, or high-ambiguity change

### Ambiguity
- Is the request clear enough to write requirements against?
- Are there hidden dependencies or unclear boundaries?

### Design Need
- Does structure, interfaces, or integration trade-offs need explicit recording?
- If yes, DESIGN is required. If clearly local, DESIGN can be skipped.

### Parallelism Potential
- Are there independent areas that can be fanned out safely?
- Are ownership boundaries clear enough for parallel execution?

### Codebase Reading
- Does the request require broad codebase reading beyond a local scope?
- If yes, plan for subagent delegation.

## Rollback

- Failure at INTAKE rolls back to INTAKE itself.
- The work is not yet started; there is no prior state to return to.

## Output

- Feature id or slug
- Complexity classification with rationale
- List of required phases (e.g., "INTAKE → SPECIFY → TASKS → EXECUTION CONTRACT → EXECUTE → VERIFY → REVIEW → FINALIZE")
- Whether DESIGN is needed
- Whether subagent delegation is needed and at what point
