# Local Quality Checks

This document describes the local quality check tooling included in the workflow package. All checks are local, self-contained, and do not require CI/CD infrastructure.

## score_workflow.sh

Each feature working set may include a `score_workflow.sh` script that runs local quality checks against the feature artifacts.

### What It Checks

| Eval | What it validates |
| --- | --- |
| artifact_coverage | All required artifacts present and non-empty |
| schema_compliance | run-history.json and state.json pass JSON schema validation |
| state_alignment | state.md and state.json agree on phase, status, last_run_id |
| state_drift | No field-level drift between state.md and state.json |
| phase_coverage | Required workflow phases are documented in run-history |
| evidence_quality | Evidence refs point to valid files, review/report have required sections |
| vocabulary_consistency | Canonical phase vocabulary used in docs and templates |

### Running the Score Script

```bash
# Run against a feature directory
bash .specs/features/<feature>/score_workflow.sh .specs/features/<feature>

# A score of 1.0 is required before considering a feature complete
```

### Pre-commit Hook (Optional)

A pre-commit hook is available to run local quality checks automatically before each commit. This is purely local — it does not involve CI infrastructure.

```bash
# Install the hook
cp scripts/pre-commit-quality-check.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

# Or use a symlink (recommended for development)
ln -sf ../../scripts/pre-commit-quality-check.sh .git/hooks/pre-commit
```

The hook runs `score_workflow.sh` on any staged feature directories. If the script returns non-zero, the commit is blocked.

### Skipping the Hook

If you need to commit without running the check:

```bash
git commit --no-verify -m "Emergency fix"
```

Use this sparingly.

## What Is Not Included

- Remote CI pipelines
- GitHub Actions
- Deploy or release automation
- PR checks
- External service integrations

All quality checks are local and self-contained. The workflow ends at local finalization.
