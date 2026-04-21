#!/usr/bin/env bash
# Score harness engineering workflow quality for a feature.
# Reads artifacts from FEATURE_DIR and outputs METRIC lines.
set -euo pipefail

FEATURE_DIR="${1:-.}"
cd "$FEATURE_DIR"

# ─── Helper: count matching elements ─────────────────────────────────────────
# Write all scoring logic in a single node script for reliability.
node --input-type=module << 'SCORE_EOF'
import { readFileSync, existsSync } from 'fs';

const ARTIFACTS = ["spec.md","eval.md","state.md","state.json","run-history.md","run-history.json","review.md","report.md"];
const TOTAL = ARTIFACTS.length;

// ── EVAL-001: Artifact Coverage ───────────────────────────────────────────────
let present = 0;
for (const a of ARTIFACTS) {
  try {
    if (existsSync(a)) {
      const stat = readFileSync(a, 'utf8');
      if (stat.length > 0) present++;
    }
  } catch {}
}
const artifact_score = present / TOTAL;
console.log(`METRIC artifact_coverage=${artifact_score.toFixed(4)} (${present}/${TOTAL} artifacts present and non-empty)`);

// ── EVAL-002: Schema Compliance ────────────────────────────────────────────────
let run_hist_valid = 0, state_valid = 0;

function validateBasicJson(path) {
  try {
    JSON.parse(readFileSync(path, 'utf8'));
    return true;
  } catch { return false; }
}

if (existsSync('run-history.json')) run_hist_valid = validateBasicJson('run-history.json') ? 1 : 0;
if (existsSync('state.json')) state_valid = validateBasicJson('state.json') ? 1 : 0;
const schema_score = (run_hist_valid + state_valid) / 2;
console.log(`METRIC schema_compliance=${schema_score.toFixed(4)} (run-history=${run_hist_valid} state=${state_valid})`);

// ── EVAL-003: State Alignment ────────────────────────────────────────────────
let alignment_score = 0.0;
try {
  if (existsSync('state.md') && existsSync('state.json')) {
    const mdLines = readFileSync('state.md', 'utf8').split('\n');
    const sj = JSON.parse(readFileSync('state.json', 'utf8'));

    function mdExtract(key) {
      for (const line of mdLines) {
        // Match "- **key**: value" or "- key: value" or "- *key*: value"
        const m = line.match(new RegExp(`^-\\s+\\*?\\*?\\s*${key}\\s*\\*?\\*?\\s*[:\\-]\\s+(\\S+)`, 'i'));
        if (m) return m[1].replace(/\*\*/g, '').replace(/\*/g, '');
      }
      return '';
    }

    const md_phase   = mdExtract('current_phase');
    const md_status  = mdExtract('status');
    const md_lastRun = mdExtract('last_run_id');

    const json_phase   = sj.current_phase || '';
    const json_status  = sj.status || '';
    const json_lastRun = sj.last_run_id || '';

    const matches = [md_phase===json_phase, md_status===json_status, md_lastRun===json_lastRun].filter(Boolean).length;
    alignment_score = matches / 3;
    console.log(`METRIC state_alignment=${alignment_score.toFixed(4)} (phase='${md_phase}'/'${json_phase}' status='${md_status}'/'${json_status}' last_run='${md_lastRun}'/'${json_lastRun}')`);
  } else {
    console.log(`METRIC state_alignment=0 (missing state.md or state.json)`);
  }
} catch(e) {
  console.log(`METRIC state_alignment=0 (error: ${e.message})`);
}

// ── EVAL-004: Phase Coverage ─────────────────────────────────────────────────
let phase_score = 0.0;
try {
  if (existsSync('run-history.json')) {
    const rh = JSON.parse(readFileSync('run-history.json', 'utf8'));
    const actualPhases = [...new Set(rh.runs.map(r => r.phase))];
    // Small feature expected phases (INTAKE may be implicit, DESIGN/TASKS skipped)
    const expected = ['SPECIFY','EVAL DEFINE','EXECUTE','VERIFY','REVIEW','REPORT','FINISH'];
    const matched = expected.filter(p => actualPhases.includes(p)).length;
    phase_score = matched / expected.length;
    console.log(`METRIC phase_coverage=${phase_score.toFixed(4)} (${matched}/${expected.length} phases covered: ${actualPhases.join(', ')})`);
  } else {
    console.log(`METRIC phase_coverage=0 (missing run-history.json)`);
  }
} catch(e) {
  console.log(`METRIC phase_coverage=0 (error: ${e.message})`);
}

// ── EVAL-005: Evidence Quality ────────────────────────────────────────────────
let evidence_score = 0.0;
try {
  let totalRefs = 0, validRefs = 0;
  let reviewHasDecision = 0, reportHasRollback = 0, stateHasRollback = 0;

  if (existsSync('run-history.json')) {
    const rh = JSON.parse(readFileSync('run-history.json', 'utf8'));
    const allRefs = rh.runs.flatMap(r => r.evidence_refs || []);
    totalRefs = allRefs.length;
    for (const ref of allRefs) {
      // Evidence refs may be relative to feature dir or absolute
      if (existsSync(ref)) { validRefs++; continue; }
      // Try relative to this script's dir (FEATURE_DIR)
      if (ref.startsWith('.specs/features/') && existsSync(ref)) validRefs++;
    }
  }

  if (existsSync('review.md')) {
    const content = readFileSync('review.md', 'utf8');
    if (/decision|pass|rework|escalate/i.test(content)) reviewHasDecision = 1;
  }

  if (existsSync('report.md')) {
    const content = readFileSync('report.md', 'utf8');
    if (/rollback/i.test(content)) reportHasRollback = 1;
  }

  if (existsSync('state.json')) {
    const sj = JSON.parse(readFileSync('state.json', 'utf8'));
    if (sj.rollback_target && sj.rollback_target !== null) stateHasRollback = 1;
  }

  const evRatio = totalRefs > 0 ? validRefs / totalRefs : 0;
  const checksPassed = (validRefs > 0 ? 1 : 0) + reviewHasDecision + reportHasRollback + stateHasRollback;
  evidence_score = (evRatio + checksPassed / 4) / 2;
  console.log(`METRIC evidence_quality=${evidence_score.toFixed(4)} (ev_refs=${validRefs}/${totalRefs} review_decision=${reviewHasDecision} report_rollback=${reportHasRollback} state_rollback=${stateHasRollback})`);
} catch(e) {
  console.log(`METRIC evidence_quality=0 (error: ${e.message})`);
}

// ── Composite Score ──────────────────────────────────────────────────────────
const quality_score = (
  artifact_score  * 0.20 +
  schema_score     * 0.20 +
  alignment_score  * 0.20 +
  phase_score      * 0.15 +
  evidence_score   * 0.25
);
console.log('');
console.log(`METRIC quality_score=${quality_score.toFixed(4)}`);
console.log('---');
console.log('Component breakdown:');
console.log(`  artifact_coverage  × 0.20 = ${artifact_score.toFixed(4)} × 0.20 = ${(artifact_score * 0.20).toFixed(4)}`);
console.log(`  schema_compliance  × 0.20 = ${schema_score.toFixed(4)} × 0.20 = ${(schema_score * 0.20).toFixed(4)}`);
console.log(`  state_alignment    × 0.20 = ${alignment_score.toFixed(4)} × 0.20 = ${(alignment_score * 0.20).toFixed(4)}`);
console.log(`  phase_coverage     × 0.15 = ${phase_score.toFixed(4)} × 0.15 = ${(phase_score * 0.15).toFixed(4)}`);
console.log(`  evidence_quality   × 0.25 = ${evidence_score.toFixed(4)} × 0.25 = ${(evidence_score * 0.25).toFixed(4)}`);
console.log('  ─────────────────────────────────────────');
console.log(`  TOTAL quality_score       = ${quality_score.toFixed(4)}`);
SCORE_EOF
