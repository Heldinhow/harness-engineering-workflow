#!/usr/bin/env bash
# Score harness engineering workflow quality for a feature.
# Reads artifacts from FEATURE_DIR and outputs METRIC lines.
set -euo pipefail

FEATURE_DIR="${1:-.}"
FEATURE_DIR_ABS="$(cd "$FEATURE_DIR" && pwd)"
cd "$FEATURE_DIR_ABS"

# All scoring logic in a single node script for reliability.
# Use quoted heredoc to avoid bash expanding $variables in regex patterns.
# FD is passed via a separate shell variable expansion before the heredoc.
FD="$FEATURE_DIR_ABS" node --input-type=module << 'SCORE_EOF'
import { readFileSync, existsSync } from 'fs';

// FD is passed as environment variable from bash
const FD = process.env.FD || '';

    function mdExtract(mdLines, key) {
      // Match lines like "- **key**: value" or "- *key*: value" or "- key: value"
      // Strip markdown from the whole line first, then split on ':'
      for (const line of mdLines) {
        const stripped = line.replace(/\*\*/g, '').replace(/\*/g, '').replace(/`/g, '').trim();
        // After stripping markdown: "- key: value"
        if (!stripped.startsWith('- ')) continue;
        const afterDash = stripped.slice(2); // "key: value"
        const colonIdx = afterDash.indexOf(':');
        if (colonIdx < 0) continue;
        const lineKey = afterDash.slice(0, colonIdx).trim();
        const lineVal = afterDash.slice(colonIdx + 1).trim().split(/\s/)[0];
        if (lineKey === key) return lineVal;
      }
      return '';
    }

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
console.log('METRIC artifact_coverage=' + artifact_score.toFixed(4) + ' (' + present + '/' + TOTAL + ' artifacts present and non-empty)');

// ── EVAL-002: Schema Compliance ────────────────────────────────────────────────
// Use ajv for strict JSON Schema validation (not just basic JSON parse).
// Falls back to basic parse if ajv is unavailable.
let run_hist_valid = 0, state_valid = 0;
let run_hist_ajv_detail = 'basic-json', state_ajv_detail = 'basic-json';

try {
  const Ajv = require('ajv');
  const ajv = new Ajv({ allErrors: true, strict: false });

  // Locate schema directory: try repo root first, then relative from feature dir
  const repoRoot = FD.replace(/\/\.specs\/features\/[^/]+$/, '');
  const schemaLocations = [
    repoRoot + '/schemas',
    FD + '/../../../../schemas',
    __dirname + '/../../../../schemas',
  ];
  const schemaDir = schemaLocations.find(loc => existsSync(loc + '/run-history.schema.json')) || '';

  if (existsSync('run-history.json') && schemaDir) {
    const runHistSchema = JSON.parse(readFileSync(schemaDir + '/run-history.schema.json', 'utf8'));
    const runHistData = JSON.parse(readFileSync('run-history.json', 'utf8'));
    const validateRunHist = ajv.compile(runHistSchema);
    const validRH = validateRunHist(runHistData);
    run_hist_valid = validRH ? 1 : 0;
    if (!validRH) run_hist_ajv_detail = 'ajv-errors:' + validateRunHist.errors.map(e => e.instancePath + ':' + e.message).join(';');
    else run_hist_ajv_detail = 'ajv-strict';
  } else {
    // Fallback: basic parse
    JSON.parse(readFileSync('run-history.json', 'utf8'));
    run_hist_valid = 1; run_hist_ajv_detail = 'basic-json';
  }

  if (existsSync('state.json') && schemaDir) {
    const stateSchema = JSON.parse(readFileSync(schemaDir + '/state.schema.json', 'utf8'));
    const stateData = JSON.parse(readFileSync('state.json', 'utf8'));
    const validateState = ajv.compile(stateSchema);
    const validST = validateState(stateData);
    state_valid = validST ? 1 : 0;
    if (!validST) state_ajv_detail = 'ajv-errors:' + validateState.errors.map(e => e.instancePath + ':' + e.message).join(';');
    else state_ajv_detail = 'ajv-strict';
  } else {
    JSON.parse(readFileSync('state.json', 'utf8'));
    state_valid = 1; state_ajv_detail = 'basic-json';
  }
} catch(e) {
  // Fallback: basic JSON parse validation
  try {
    if (existsSync('run-history.json')) { JSON.parse(readFileSync('run-history.json', 'utf8')); run_hist_valid = 1; }
    if (existsSync('state.json')) { JSON.parse(readFileSync('state.json', 'utf8')); state_valid = 1; }
    run_hist_ajv_detail = 'basic-json-fallback';
    state_ajv_detail = 'basic-json-fallback';
  } catch {}
}

const schema_score = (run_hist_valid + state_valid) / 2;
console.log('METRIC schema_compliance=' + schema_score.toFixed(4) + ' (run-history=' + run_hist_valid + '[' + run_hist_ajv_detail + '] state=' + state_valid + '[' + state_ajv_detail + '])');

// ── EVAL-003: State Alignment ─────────────────────────────────────────────────
let alignment_score = 0.0;
try {
  if (existsSync('state.md') && existsSync('state.json')) {
    const mdLines = readFileSync('state.md', 'utf8').split('\n');
    const sj = JSON.parse(readFileSync('state.json', 'utf8'));





    const md_phase   = mdExtract(mdLines, 'current_phase');
    const md_status  = mdExtract(mdLines, 'status');
    const md_lastRun = mdExtract(mdLines, 'last_run_id');
    const json_phase   = sj.current_phase || '';
    const json_status  = sj.status || '';
    const json_lastRun = sj.last_run_id || '';
    const matches = [md_phase===json_phase, md_status===json_status, md_lastRun===json_lastRun].filter(Boolean).length;
    alignment_score = matches / 3;
    console.log('METRIC state_alignment=' + alignment_score.toFixed(4) + " (phase='" + md_phase + "'/'" + json_phase + "' status='" + md_status + "'/'" + json_status + "' last_run='" + md_lastRun + "'/'" + json_lastRun + "')");
  } else {
    console.log('METRIC state_alignment=0 (missing state.md or state.json)');
  }
} catch(e) {
  console.log('METRIC state_alignment=0 (error: ' + e.message + ')');
}

// ── EVAL-004: Phase Coverage ──────────────────────────────────────────────────
let phase_score = 0.0;
try {
  if (existsSync('run-history.json')) {
    const rh = JSON.parse(readFileSync('run-history.json', 'utf8'));
    const actualPhases = [...new Set(rh.runs.map(r => r.phase))];
    const expected = ['SPECIFY','EVAL DEFINE','EXECUTE','VERIFY','REVIEW','REPORT','FINISH'];
    const matched = expected.filter(p => actualPhases.includes(p)).length;
    phase_score = matched / expected.length;
    console.log('METRIC phase_coverage=' + phase_score.toFixed(4) + ' (' + matched + '/' + expected.length + ' phases covered: ' + actualPhases.join(', ') + ')');
  } else {
    console.log('METRIC phase_coverage=0 (missing run-history.json)');
  }
} catch(e) {
  console.log('METRIC phase_coverage=0 (error: ' + e.message + ')');
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
      if (existsSync(ref)) { validRefs++; continue; }
      // Try absolute path from feature dir
      const absRef = ref.startsWith('/') ? ref : FD + '/' + ref;
      if (existsSync(absRef)) { validRefs++; continue; }
      // Try repo-root relative (evidence refs often stored as .specs/features/FEATURE/...)
      const repoRoot = FD.replace(/\/.specs\/features\/[^/]+$/, '');
      if (existsSync(repoRoot + '/' + ref)) { validRefs++; continue; }
      // Try stripped ref
      const stripped = ref.replace(/^\.specs\/features\/[^/]+\//, '');
      if (stripped !== ref && existsSync(FD + '/' + stripped)) { validRefs++; }
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
  console.log('METRIC evidence_quality=' + evidence_score.toFixed(4) + ' (ev_refs=' + validRefs + '/' + totalRefs + ' review_decision=' + reviewHasDecision + ' report_rollback=' + reportHasRollback + ' state_rollback=' + stateHasRollback + ')');
} catch(e) {
  console.log('METRIC evidence_quality=0 (error: ' + e.message + ')');
}

// ── EVAL-006: State Drift Detection ───────────────────────────────────────────
let drift_score = 1.0;
const drift_fields = ['feature_id','complexity','current_phase','status','owner_role','last_run_id','rollback_target'];
try {
  if (existsSync('state.md') && existsSync('state.json')) {
    const mdLines = readFileSync('state.md', 'utf8').split('\n');
    const sj = JSON.parse(readFileSync('state.json', 'utf8'));

    let mismatches = 0;
    for (const key of drift_fields) {
      const mdVal = mdExtract(mdLines, key);
      const jsonVal = (sj[key] || '').toString();
      if (mdVal !== jsonVal) {
        mismatches++;
        console.log('  DRIFT: state.' + key + " mismatch: md='" + mdVal + "' vs json='" + jsonVal + "'");
      }
    }
    if (mismatches === 0) drift_score = 1.0;
    else if (mismatches === 1) drift_score = 0.5;
    else drift_score = 0.0;
    console.log('METRIC state_drift=' + drift_score.toFixed(4) + ' (' + mismatches + ' mismatches across ' + drift_fields.length + ' shared fields)');
  } else {
    console.log('METRIC state_drift=0 (missing state.md or state.json)');
  }
} catch(e) {
  console.log('METRIC state_drift=0 (error: ' + e.message + ')');
}

// ── Composite Score ───────────────────────────────────────────────────────────
const quality_score = (
  artifact_score  * 0.20 +
  schema_score    * 0.20 +
  alignment_score * 0.20 +
  drift_score     * 0.10 +
  phase_score     * 0.10 +
  evidence_score  * 0.20
);
console.log('');
console.log('METRIC quality_score=' + quality_score.toFixed(4));
console.log('---');
console.log('Component breakdown:');
console.log('  artifact_coverage  x 0.20 = ' + artifact_score.toFixed(4) + ' x 0.20 = ' + (artifact_score * 0.20).toFixed(4));
console.log('  schema_compliance  x 0.20 = ' + schema_score.toFixed(4) + ' x 0.20 = ' + (schema_score * 0.20).toFixed(4));
console.log('  state_alignment    x 0.20 = ' + alignment_score.toFixed(4) + ' x 0.20 = ' + (alignment_score * 0.20).toFixed(4));
console.log('  state_drift        x 0.10 = ' + drift_score.toFixed(4) + ' x 0.10 = ' + (drift_score * 0.10).toFixed(4));
console.log('  phase_coverage     x 0.10 = ' + phase_score.toFixed(4) + ' x 0.10 = ' + (phase_score * 0.10).toFixed(4));
console.log('  evidence_quality   x 0.20 = ' + evidence_score.toFixed(4) + ' x 0.20 = ' + (evidence_score * 0.20).toFixed(4));
console.log('  --------------------------------------------------------');
console.log('  TOTAL quality_score       = ' + quality_score.toFixed(4));
SCORE_EOF
