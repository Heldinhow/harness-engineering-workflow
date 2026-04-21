# Spec: multi-agent-installer

## Objective

Transform this repository into an installable workflow package by adding a universal installer that detects Claude Code, Codex, Copilot CLI, OpenCode, ForgeCode and other coding agents, adapts core assets for each target platform, and supports install/update/doctor/uninstall operations.

## Context

The repository already provides an operational SDD + Harness Engineering workflow package with skills, templates, schemas, and docs (per README.md:3-12 and README.md:52-94). The next iteration makes this package distributable: a single installer command detects which coding agents are present and installs the workflow assets in the correct locations and formats for each target.

## Scope

### In
- A manifest declaring which assets are installable and how they map to targets.
- A target detection layer that identifies installed coding agents.
- A shell-based installer with adapters for each supported target.
- An installed-state file recording what was installed, where, and in which mode.
- Commands: install, update, uninstall, doctor, list-targets, status.
- Capability matrix per target: full / adapted / fallback / unsupported.
- Documentation of the install process in README.md.

### Out
- Native packages (npm, pip, brew) — defer to a future iteration.
- Runtime enforcement of schema validation during installation.
- Telemetry or remote registry — defer to a future iteration.

## Requirements

### REQ-001
- WHEN a user runs the installer THEN the installer SHALL detect which coding agents are present on the system (claude-code, codex, copilot-cli, opencode, forgecode) and report their status.

### REQ-002
- WHEN a user runs `install --all` or names specific targets THEN the installer SHALL copy or render core assets to the correct locations for each target using the appropriate adapter.

### REQ-003
- WHEN installing for a target that supports native skills THEN the installer SHALL install the `skills/` content in the format that target expects.

### REQ-004
- WHEN installing for a target that does not support native skills THEN the installer SHALL install a fallback mode using `AGENTS.md`, templates, and bootstrap prompts.

### REQ-005
- WHEN the installer completes successfully THEN it SHALL write an installed-state file recording target, version, paths, mode, and timestamp.

### REQ-006
- WHEN a user runs `doctor` THEN the installer SHALL verify each target's installation is intact and report mode, missing files, and path correctness.

### REQ-007
- WHEN a user runs `update` THEN the installer SHALL reapply adapters for installed targets without overwriting user customizations.

### REQ-008
- WHEN a user runs `uninstall` THEN the installer SHALL remove only the files it created and leave user content untouched.

### REQ-009
- WHEN the installer runs twice with the same arguments THEN the result SHALL be identical to running it once (idempotent).

### REQ-010
- WHEN the installer starts it SHALL display a capability matrix showing which targets are supported and their current install status.

## Acceptance Criteria

- `install.sh --all` installs the package for all detected agents.
- `install.sh --target claude-code` installs only for Claude Code.
- Each target installs in mode: `full`, `adapted`, or `fallback`.
- `install.sh doctor` reports the status of all installed targets.
- `install.sh update` re-applies adapters without data loss.
- `install.sh uninstall` removes only installer-managed files.
- Running install twice produces no duplicate files or errors.
- Installed-state file exists at `~/.config/harness-workflow/installed.json` after successful install.
- README.md documents the install process.

## Constraints

- The installer MUST work on macOS and Linux.
- The installer MUST NOT require Python, Node, or any runtime beyond a POSIX shell.
- Core assets remain the source of truth; adapters transform on install.
- No external network calls during normal install/update (offline-first).

## Dependencies

- Existing `skills/`, `templates/`, `schemas/` directories.
- Existing `AGENTS.md` at root.
- Existing `README.md` for documentation updates.

## Notes

- This feature dogfoods the workflow by keeping its own artifacts under `.specs/features/multi-agent-installer/`.
