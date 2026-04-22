# CI Integration

## Pre-commit Quality Hook

The workflow includes an automated pre-commit hook that runs `score_workflow.sh` on any staged feature artifacts before each commit.

### What It Does

Before `git commit` completes, the hook:

1. Detects which feature directories have staged changes.
2. Runs `score_workflow.sh` on each changed feature.
3. Blocks the commit if any quality score is below 1.0.

This ensures that state drift, missing phases, invalid JSON, and broken evidence refs are caught automatically.

### Installation

**Automatic (via installer):**
```bash
installer/install.sh --target claude-code --install-hooks
```

**Manual:**
```bash
# Option A: Copy the hook
cp scripts/pre-commit-quality-check.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

# Option B: Symlink (recommended for development)
ln -sf ../../scripts/pre-commit-quality-check.sh .git/hooks/pre-commit
```

### How It Works

```
git commit → pre-commit hook → score_workflow.sh → [pass/fail] → [commit/abort]
```

The hook reads staged files, identifies feature directories under `.specs/features/`, and invokes each feature's `score_workflow.sh`. If the script returns non-zero, the commit is blocked.

### What Gets Checked

| Eval | What it validates |
|------|-----------------|
| artifact_coverage | All 8 required artifacts present and non-empty |
| schema_compliance | run-history.json and state.json pass JSON schema (ajv strict) |
| state_alignment | state.md and state.json agree on phase, status, last_run_id |
| state_drift | No field-level drift between state.md and state.json |
| phase_coverage | Required workflow phases are documented in run-history |
| evidence_quality | Evidence refs point to valid files, review/report have required sections |
| ci_hook | Pre-commit hook exists and is executable |

### Skipping the Hook

If you need to commit without running the check (e.g., emergency fix):

```bash
git commit --no-verify -m "Emergency fix"
```

Use this sparingly — the hook exists to protect workflow integrity.

### CI in Non-git Contexts

For agents without git access, run the scoring script directly:

```bash
bash .specs/features/<feature>/score_workflow.sh .specs/features/<feature>
```

A score of 1.0 is required before considering a feature complete.
