# Eval Definition: multi-agent-installer

## Evals

### EVAL-001
- Type: capability
- Maps to: REQ-001, REQ-002, REQ-003, REQ-004, REQ-009
- Description: The installer correctly detects all supported coding agents and installs assets in the correct locations and format for each target.
- Evidence method: Run `installer/install.sh --dry-run --all` and verify the output shows detection of present agents and correct file mappings per target.
- Rerun triggers:
  - Changes to `installer/lib/detect.sh`
  - Changes to any adapter in `installer/targets/`
  - Changes to `installer/install.sh`
- Thresholds:
  - All detected agents show a capability mode (full/adapted/fallback).
  - No "not detected" agents are listed as installable.
  - Dry-run output is idempotent (running twice produces identical output).

### EVAL-002
- Type: capability
- Maps to: REQ-005, REQ-006, REQ-007, REQ-008, REQ-009
- Description: The installer correctly manages installed state and supports doctor, update, and uninstall operations without data loss.
- Evidence method: Run `installer/install.sh --dry-run --all` then verify state file exists and is valid JSON. Run `installer/doctor.sh` and verify it reports status for all installed targets.
- Rerun triggers:
  - Changes to `installer/lib/state.sh`
  - Changes to `installer/doctor.sh`
  - Changes to `installer/update.sh`
  - Changes to `installer/uninstall.sh`
- Thresholds:
  - Installed-state file is valid JSON matching the expected schema.
  - Doctor output shows mode and file status for each installed target.
  - Uninstall removes only installer-managed files.

### EVAL-003
- Type: regression
- Maps to: REQ-010
- Description: README.md documents the install process correctly and the installer does not break existing repository structure.
- Evidence method: Inspect README.md for install/uninstall/doctor/update sections. Verify `installer/` directory does not conflict with existing top-level directories.
- Rerun triggers:
  - Changes to `README.md`
  - Changes to `installer/install.sh`
- Thresholds:
  - README.md contains a "Installation" section with `curl` bootstrap command.
  - README.md documents all five commands: install, update, uninstall, doctor, list-targets.
  - `installer/` does not overwrite or conflict with `skills/`, `templates/`, `schemas/`, or `AGENTS.md`.

## Notes

- Eval 001 focuses on detection and installation correctness per target.
- Eval 002 focuses on state management and lifecycle operations.
- Eval 003 focuses on documentation and non-regression.
