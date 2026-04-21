# Tasks: multi-agent-installer

## Execution Mode
- Inline

## Tasks

### TASK-001
Objective: Create the installer directory structure, manifest, and core library files.
Maps to: REQ-001, REQ-002, REQ-010
Related evals: EVAL-001, EVAL-002
Owner role: Orchestrator
Execution class: sequential
Depends on: none
Required artifacts:
- `.specs/features/multi-agent-installer/spec.md`
Files/areas:
- `installer/`
Ready definition:
- Feature spec is approved.
Done definition:
- `installer/` directory exists with `install.sh`, `doctor.sh`, `uninstall.sh`, `update.sh`, `list-targets.sh`, `status.sh`, `lib/`, and `targets/` subdirectories.
Expected evidence:
- Directory tree output showing created files.

### TASK-002
Objective: Implement target detection logic in `installer/lib/detect.sh`.
Maps to: REQ-001
Related evals: EVAL-001
Owner role: Execution Agent
Execution class: sequential
Depends on: TASK-001
Required artifacts:
- `installer/lib/detect.sh`
Files/areas:
- `installer/lib/detect.sh`
Ready definition:
- `installer/` directory structure exists.
Done definition:
- `detect.sh` defines functions to detect: claude-code, codex, copilot-cli, opencode, forgecode.
Expected evidence:
- Source and test output of each detection function.

### TASK-003
Objective: Implement the capability matrix and installed-state management in `installer/lib/state.sh`.
Maps to: REQ-005, REQ-009
Related evals: EVAL-002
Owner role: Execution Agent
Execution class: sequential
Depends on: TASK-001
Required artifacts:
- `installer/lib/state.sh`
Files/areas:
- `installer/lib/state.sh`
Ready definition:
- `installer/` directory structure exists.
Done definition:
- `state.sh` can read and write installed-state JSON to `~/.config/harness-workflow/installed.json`.
Expected evidence:
- State read/write test output showing correct JSON round-trip.

### TASK-004
Objective: Implement the adapter for Claude Code in `installer/targets/claude-code.sh`.
Maps to: REQ-002, REQ-003
Related evals: EVAL-001
Owner role: Execution Agent
Execution class: sequential
Depends on: TASK-002, TASK-003
Required artifacts:
- `installer/targets/claude-code.sh`
Files/areas:
- `installer/targets/claude-code.sh`
Ready definition:
- Detection and state library functions exist.
Done definition:
- Adapter installs skills to Claude Code skills directory and copies AGENTS.md.
Expected evidence:
- Dry-run output showing files that would be installed.

### TASK-005
Objective: Implement the adapter for Codex in `installer/targets/codex.sh`.
Maps to: REQ-002, REQ-004
Related evals: EVAL-001
Owner role: Execution Agent
Execution class: sequential
Depends on: TASK-002, TASK-003
Required artifacts:
- `installer/targets/codex.sh`
Files/areas:
- `installer/targets/codex.sh`
Ready definition:
- Detection and state library functions exist.
Done definition:
- Adapter installs in `adapted` mode using prompts directory.
Expected evidence:
- Dry-run output showing files that would be installed.

### TASK-006
Objective: Implement the adapter for Copilot CLI in `installer/targets/copilot-cli.sh`.
Maps to: REQ-002, REQ-004
Related evals: EVAL-001
Owner role: Execution Agent
Execution class: sequential
Depends on: TASK-002, TASK-003
Required artifacts:
- `installer/targets/copilot-cli.sh`
Files/areas:
- `installer/targets/copilot-cli.sh`
Ready definition:
- Detection and state library functions exist.
Done definition:
- Adapter installs in `adapted` mode using Copilot CLI conventions.
Expected evidence:
- Dry-run output showing files that would be installed.

### TASK-007
Objective: Implement the generic fallback adapter in `installer/targets/fallback.sh`.
Maps to: REQ-002, REQ-004
Related evals: EVAL-001
Owner role: Execution Agent
Execution class: sequential
Depends on: TASK-002, TASK-003
Required artifacts:
- `installer/targets/fallback.sh`
Files/areas:
- `installer/targets/fallback.sh`
Ready definition:
- Detection and state library functions exist.
Done definition:
- Fallback adapter installs AGENTS.md and templates for any target.
Expected evidence:
- Dry-run output showing files that would be installed.

### TASK-008
Objective: Implement doctor, uninstall, update, list-targets, and status commands.
Maps to: REQ-006, REQ-007, REQ-008
Related evals: EVAL-002, EVAL-003
Owner role: Execution Agent
Execution class: sequential
Depends on: TASK-003, TASK-004, TASK-005, TASK-006, TASK-007
Required artifacts:
- `installer/doctor.sh`
- `installer/uninstall.sh`
- `installer/update.sh`
- `installer/list-targets.sh`
- `installer/status.sh`
Files/areas:
- `installer/*.sh`
Ready definition:
- All adapter scripts exist.
Done definition:
- All commands function correctly with appropriate exit codes.
Expected evidence:
- Output of each command showing expected behavior.

### TASK-009
Objective: Update README.md to document the install process and update root AGENTS.md if needed.
Maps to: REQ-010
Related evals: EVAL-003
Owner role: Execution Agent
Execution class: sequential
Depends on: TASK-004, TASK-005, TASK-006, TASK-007, TASK-008
Required artifacts:
- `README.md`
Files/areas:
- `README.md`
Ready definition:
- Installer and all adapters are functional.
Done definition:
- README.md contains install/uninstall/doctor/update instructions.
Expected evidence:
- README.md sections reviewed and updated.

### TASK-010
Objective: Verify the full installer implementation with fresh evidence.
Maps to: REQ-001, REQ-002, REQ-005, REQ-006, REQ-009
Related evals: EVAL-001, EVAL-002, EVAL-003
Owner role: Reviewer
Execution class: sequential
Depends on: TASK-009
Required artifacts:
- `.specs/features/multi-agent-installer/state.md`
- `.specs/features/multi-agent-installer/state.json`
- `.specs/features/multi-agent-installer/run-history.md`
- `.specs/features/multi-agent-installer/run-history.json`
Files/areas:
- `.specs/features/multi-agent-installer/`
Ready definition:
- All installer components and documentation are complete.
Done definition:
- Installer passes all eval criteria and review decision is recorded.
Expected evidence:
- Verification commands run successfully.
