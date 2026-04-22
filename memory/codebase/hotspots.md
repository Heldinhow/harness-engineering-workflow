# Codebase Memory Hotspots

## High-coupling areas

### 1. Workflow vocabulary
- Files: `README.md`, `AGENTS.md`, `docs/workflow/*.md`, `docs/roles/*.md`, `docs/standards/*.md`, `skills/*/SKILL.md`, `templates/*.md`, `memory/**/*.md`
- Risk: phase names, role names, or decision names drift.
- Update together when changing workflow language.

### 2. State and run-history model
- Files: `docs/workflow/phases-and-gates.md`, `templates/state.*`, `templates/run-history.*`, `schemas/*.json`
- Risk: Markdown, JSON, and schema contracts stop matching.
- Check both human and machine-readable forms together.

### 3. Delegation and subagent rules
- Files: `AGENTS.md`, `docs/roles/codebase-reader.md`, `docs/standards/subagent-boundaries.md`, `docs/standards/parallelism.md`, `skills/harness-engineering-workflow/SKILL.md`
- Risk: the Orchestrator-first model becomes inconsistent.
- Keep reading limits and output contracts identical.

### 4. New phase artifacts
- Files: `templates/execution-contract.md`, `templates/finalize-report.md`, `docs/workflow/execution-contract.md`, `docs/workflow/finalize.md`
- Risk: these are new; keep them aligned with the phase table in `docs/workflow/phases-and-gates.md`.

### 5. Installer manifest
- Files: `installer/lib/manifest.sh`
- Risk: if `docs/` is not included in installed assets, the new short `AGENTS.md` becomes less useful outside the repo.

## Safe update habit
- Before editing a hotspot, identify the matching mirror files first.
- After editing, do a focused consistency pass instead of assuming one source of truth is enough.
