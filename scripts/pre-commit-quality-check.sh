#!/usr/bin/env bash
# pre-commit hook: run harness workflow quality check on changed features.
# Install: cp scripts/pre-commit-quality-check.sh .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit
# Or: ln -sf ../../scripts/pre-commit-quality-check.sh .git/hooks/pre-commit
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(git rev-parse --show-toplevel)"
SCORE_SCRIPT=""

# Find score_workflow.sh in changed feature directories
changed_features=$(git diff --cached --name-only --diff-filter=ACM | \
  grep '\.specs/features/' | \
  sed 's|\.specs/features/\([^/]*\)/.*|\1|' | \
  sort -u)

if [[ -z "$changed_features" ]]; then
  echo "[harness] No feature artifacts staged — skipping quality check."
  exit 0
fi

echo "[harness] Running quality check on staged features..."
echo "Changed features: $changed_features"

exit_code=0
for feature in $changed_features; do
  feature_dir="$REPO_ROOT/.specs/features/$feature"
  score_script="$feature_dir/score_workflow.sh"

  if [[ -f "$score_script" ]]; then
    echo ""
    echo "[harness] Scoring $feature..."
    if bash "$score_script" "$feature_dir"; then
      echo "[harness] ✓ $feature passed quality check"
    else
      echo "[harness] ✗ $feature FAILED quality check"
      exit_code=1
    fi
  else
    echo "[harness] ⚠  No score_workflow.sh in $feature — skipping"
  fi
done

if [[ $exit_code -eq 0 ]]; then
  echo ""
  echo "[harness] ✓ All staged features passed quality check."
else
  echo ""
  echo "[harness] ✗ Quality check failed. Fix issues before committing."
  echo "[harness] Run score_workflow.sh manually to see details."
fi

exit $exit_code
