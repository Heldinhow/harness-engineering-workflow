#!/usr/bin/env bash
# Score harness engineering workflow quality for a feature.
# Reads artifacts from FEATURE_DIR and outputs METRIC lines.
set -euo pipefail

FEATURE_DIR="${1:-.}"
FEATURE_DIR_ABS="$(cd "$FEATURE_DIR" && pwd)"
cd "$FEATURE_DIR_ABS"

# ── Score computation in node.js ───────────────────────────────────────────────
# Quoted heredoc: bash doesn't expand variables, preventing regex/string mangling.
# FD is passed as environment variable.
FD="$FEATURE_DIR_ABS" node --input-type=module << 'SCORE_EOF'
import { readFileSync, existsSync, accessSync, constants } from 'fs';

const FD = process.env.FD || '';
const ARTIFACTS = ["spec.md","eval.md","state.md","state.json","run-history.md","run-history.json","review.md","report.md"];
const TOTAL = ARTIFACTS.length;

// ── Helper: mdExtract (module-level, takes mdLines param) ─────────────────────
function mdExtract(mdLines, key) {
  for (const line of mdLines) {
    const stripped = line.replace(/\*\*/g, '').replace(/\*/g, '').replace(/`/g, '').trim();
    if (!stripped.startsWith('- ')) continue;
    const afterDash = stripped.slice(2);
    const colonIdx = afterDash.indexOf(':');
    if (colonIdx < 0) continue;
    const lineKey = afterDash.slice(0, colonIdx).trim();
    const lineVal = afterDash.slice(colonIdx + 1).trim().split(/\s/)[0];
    if (lineKey === key) return lineVal;
  }
  return '';
}

// ── EVAL-001: Artifact Coverage ───────────────────────────────────────────────
let present = 0;
for (const a of ARTIFACTS) {
  try { if (existsSync(a) && readFileSync(a, 'utf8').length > 0) present++; } catch {}
}
const artifact_score = present / TOTAL;
console.log('METRIC artifact_coverage=' + artifact_score.toFixed(4) + ' (' + present + '/' + TOTAL + ' artifacts present and non-empty)');

// ── EVAL-002: Schema Compliance ───────────────────────────────────────────────
let run_hist_valid = 0, state_valid = 0, ajv_detail_rh = 'unavailable', ajv_detail_st = 'unavailable';
try {
  const Ajv = require('ajv');
  const ajv = new Ajv({ allErrors: true, strict: false });
  const repoRoot = FD.replace(/\/.specs\/features\/[^/]+$/, '');
  const schemaDir = existsSync(repoRoot + '/schemas/run-history.schema.json') ? repoRoot + '/schemas' : '';

  if (existsSync('run-history.json') && schemaDir) {
    const validateRH = ajv.compile(JSON.parse(readFileSync(schemaDir + '/run-history.schema.json', 'utf8')));
    const validRH = validateRH(JSON.parse(readFileSync('run-history.json', 'utf8')));
    run_hist_valid = validRH ? 1 : 0;
    ajv_detail_rh = validRH ? 'ajv-pass' : 'ajv-fail:' + validateRH.errors.map(e => e.instancePath + ':' + e.message).join(';');
  } else {
    JSON.parse(readFileSync('run-history.json', 'utf8')); run_hist_valid = 1; ajv_detail_rh = 'basic-json';
  }
  if (existsSync('state.json') && schemaDir) {
    const validateST = ajv.compile(JSON.parse(readFileSync(schemaDir + '/state.schema.json', 'utf8')));
    const validST = validateST(JSON.parse(readFileSync('state.json', 'utf8')));
    state_valid = validST ? 1 : 0;
    ajv_detail_st = validST ? 'ajv-pass' : 'ajv-fail:' + validateST.errors.map(e => e.instancePath + ':' + e.message).join(';');
  } else {
    JSON.parse(readFileSync('state.json', 'utf8')); state_valid = 1; ajv_detail_st = 'basic-json';
  }
} catch(e) {
  try { JSON.parse(readFileSync('run-history.json', 'utf8')); run_hist_valid = 1; } catch {}
  try { JSON.parse(readFileSync('state.json', 'utf8')); state_valid = 1; } catch {}
  ajv_detail_rh = 'error:' + e.message;
  ajv_detail_st = 'error:' + e.message;
}
const schema_score = (run_hist_valid + state_valid) / 2;
console.log('METRIC schema_compliance=' + schema_score.toFixed(4) + ' (run-hist=' + run_hist_valid + '[' + ajv_detail_rh + '] state=' + state_valid + '[' + ajv_detail_st + '])');

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
    // Small feature expected phases (INTAKE may be implicit, DESIGN/TASKS skipped)
    const expected = ['SPECIFY','EVAL DEFINE','EXECUTE','VERIFY','REVIEW','REPORT','FINISH'];
    const matched = expected.filter(p => actualPhases.includes(p)).length;
    phase_score = matched / expected.length;
    console.log('METRIC phase_coverage=' + phase_score.toFixed(4) + ' (' + matched + '/' + expected.length + ' phases: ' + actualPhases.join(', ') + ')');
  } else {
    console.log('METRIC phase_coverage=0 (missing run-history.json)');
  }
} catch(e) {
  console.log('METRIC phase_coverage=0 (error: ' + e.message + ')');
}

// ── EVAL-005: Evidence Quality ───────────────────────────────────────────────
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
      const absRef = ref.startsWith('/') ? ref : FD + '/' + ref;
      if (existsSync(absRef)) { validRefs++; continue; }
      const repoRoot = FD.replace(/\/.specs\/features\/[^/]+$/, '');
      if (existsSync(repoRoot + '/' + ref)) { validRefs++; continue; }
      const stripped = ref.replace(/^\.specs\/features\/[^/]+\//, '');
      if (stripped !== ref && existsSync(FD + '/' + stripped)) { validRefs++; }
    }
  }
  if (existsSync('review.md')) { const c = readFileSync('review.md', 'utf8'); if (/decision|pass|rework|escalate/i.test(c)) reviewHasDecision = 1; }
  if (existsSync('report.md')) { const c = readFileSync('report.md', 'utf8'); if (/rollback/i.test(c)) reportHasRollback = 1; }
  if (existsSync('state.json')) { const sj = JSON.parse(readFileSync('state.json', 'utf8')); if (sj.rollback_target) stateHasRollback = 1; }
  const evRatio = totalRefs > 0 ? validRefs / totalRefs : 0;
  const checks = (validRefs > 0 ? 1 : 0) + reviewHasDecision + reportHasRollback + stateHasRollback;
  evidence_score = (evRatio + checks / 4) / 2;
  console.log('METRIC evidence_quality=' + evidence_score.toFixed(4) + ' (ev_refs=' + validRefs + '/' + totalRefs + ' review=' + reviewHasDecision + ' report_rollback=' + reportHasRollback + ' state_rollback=' + stateHasRollback + ')');
} catch(e) {
  console.log('METRIC evidence_quality=0 (error: ' + e.message + ')');
}

// ── EVAL-006: State Drift Detection ──────────────────────────────────────────
let drift_score = 1.0;
try {
  if (existsSync('state.md') && existsSync('state.json')) {
    const mdLines = readFileSync('state.md', 'utf8').split('\n');
    const sj = JSON.parse(readFileSync('state.json', 'utf8'));
    const drift_fields = ['feature_id','complexity','current_phase','status','owner_role','last_run_id','rollback_target'];
    let mismatches = 0;
    for (const key of drift_fields) {
      const mdVal = mdExtract(mdLines, key);
      const jsonVal = (sj[key] || '').toString();
      if (mdVal !== jsonVal) { mismatches++; console.log('  DRIFT: ' + key + " md='" + mdVal + "' json='" + jsonVal + "'"); }
    }
    if (mismatches === 0) drift_score = 1.0;
    else if (mismatches === 1) drift_score = 0.5;
    else drift_score = 0.0;
    console.log('METRIC state_drift=' + drift_score.toFixed(4) + ' (' + mismatches + ' mismatches across ' + drift_fields.length + ' fields)');
  } else {
    console.log('METRIC state_drift=0 (missing state.md or state.json)');
  }
} catch(e) {
  console.log('METRIC state_drift=0 (error: ' + e.message + ')');
}

// ── EVAL-007: CI Pre-commit Hook ─────────────────────────────────────────────
let ci_hook_score = 0.0;
try {
  const repoRoot = FD.replace(/\/.specs\/features\/[^/]+$/, '');
  const hookPath = repoRoot + '/scripts/pre-commit-quality-check.sh';
  const hookExists = existsSync(hookPath);
  let hookExecutable = false;
  if (hookExists) {
    try { accessSync(hookPath, constants.X_OK); hookExecutable = true; } catch {}
  }
  if (hookExists && hookExecutable) { ci_hook_score = 1.0; console.log('METRIC ci_hook=1.0000 (hook exists and is executable)'); }
  else if (hookExists) { ci_hook_score = 0.5; console.log('METRIC ci_hook=0.5000 (hook exists but not executable)'); }
  else { console.log('METRIC ci_hook=0.0000 (hook missing: ' + hookPath + ')'); }
} catch(e) {
  console.log('METRIC ci_hook=0.0000 (error: ' + e.message + ')');
}

// ── Composite Score ──────────────────────────────────────────────────────────
const quality_score = (
  artifact_score  * 0.15 +
  schema_score    * 0.15 +
  alignment_score * 0.15 +
  drift_score     * 0.10 +
  phase_score     * 0.10 +
  evidence_score  * 0.15 +
  ci_hook_score   * 0.20
);
console.log('');
console.log('METRIC quality_score=' + quality_score.toFixed(4));
console.log('---');
console.log('Component breakdown:');
console.log('  artifact_coverage  x 0.15 = ' + artifact_score.toFixed(4) + ' x 0.15 = ' + (artifact_score * 0.15).toFixed(4));
console.log('  schema_compliance  x 0.15 = ' + schema_score.toFixed(4) + ' x 0.15 = ' + (schema_score * 0.15).toFixed(4));
console.log('  state_alignment    x 0.15 = ' + alignment_score.toFixed(4) + ' x 0.15 = ' + (alignment_score * 0.15).toFixed(4));
console.log('  state_drift        x 0.10 = ' + drift_score.toFixed(4) + ' x 0.10 = ' + (drift_score * 0.10).toFixed(4));
console.log('  phase_coverage     x 0.10 = ' + phase_score.toFixed(4) + ' x 0.10 = ' + (phase_score * 0.10).toFixed(4));
console.log('  evidence_quality   x 0.15 = ' + evidence_score.toFixed(4) + ' x 0.15 = ' + (evidence_score * 0.15).toFixed(4));
console.log('  ci_hook            x 0.20 = ' + ci_hook_score.toFixed(4) + ' x 0.20 = ' + (ci_hook_score * 0.20).toFixed(4));
console.log('  --------------------------------------------------------');
console.log('  TOTAL quality_score       = ' + quality_score.toFixed(4));
SCORE_EOF
