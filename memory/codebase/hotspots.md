# Codebase Memory Hotspots

## High-coupling areas

### 1. Workflow vocabulary
- Files: `README.md`, `AGENTS.md`, `docs/workflow/*.md`, `skills/*/SKILL.md`, `templates/*.md`, `memory/**/*.md`
- Risk: phase names, role names, or decision names drift.
- Update together when changing workflow language.

### 2. State and run-history model
- Files: `docs/workflow/state-and-runs.md`, `templates/state.*`, `templates/run-history.*`, `schemas/*.json`
- Risk: Markdown, JSON, and schema contracts stop matching.
- Check both human and machine-readable forms together.

### 3. Delegation and codebase-reading rules
- Files: `AGENTS.md`, `docs/workflow/codebase-reading.md`, `docs/workflow/delegation.md`, `docs/workflow/agent-roles.md`, `skills/harness-engineering-workflow/SKILL.md`
- Risk: the Orchestrator-first model becomes inconsistent.
- Keep reading limits and output contracts identical.

### 4. Memory layer itself
- Files: `memory/project/*.md`, `memory/codebase/*.md`
- Risk: memory becomes stale after structure or workflow changes.
- Refresh memory whenever repo layout, read order, or hot spots change.

## Current notable mismatch
- Example trees are concise on purpose, so they may show one representative path rather than every possible workflow branch.
- Keep examples aligned with `templates/` and `schemas/` whenever those contracts change.

## Safe update habit
- Before editing a hotspot, identify the matching mirror files first.
- After editing, do a focused consistency pass instead of assuming one source of truth is enough.
