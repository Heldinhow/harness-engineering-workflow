#!/usr/bin/env bash
# Score harness engineering workflow quality for a feature.
# Reads artifacts from FEATURE_DIR and outputs METRIC lines.
set -euo pipefail

FEATURE_DIR="${1:-.}"
FEATURE_DIR_ABS="$(cd "$FEATURE_DIR" && pwd)"
cd "$FEATURE_DIR_ABS"

FD="$FEATURE_DIR_ABS" node --input-type=module << 'SCORE_EOF'
import { readFileSync, existsSync, accessSync, constants } from 'fs';

const FD = process.env.FD || '';
const ARTIFACTS = ["spec.md","eval.md","state.md","state.json","run-history.md","run-history.json","review.md","report.md"];
const TOTAL = ARTIFACTS.length;

// Helper: extract field from state.md (handles bold/italic markdown)
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

// Helper: check if array of numbers is sequential (REQ-001, REQ-002, ...)
function isSequential(arr) { return arr.length > 0 && arr.every((n, i) => i === 0 || n === arr[i-1] + 1); }

// ── EVAL-001: Artifact Coverage ───────────────────────────────────────────────
let present = 0;
for (const a of ARTIFACTS) {
  try { if (existsSync(a) && readFileSync(a, 'utf8').length > 0) present++; } catch {}
}
const artifact_score = present / TOTAL;
console.log('METRIC artifact_coverage=' + artifact_score.toFixed(4) + ' (' + present + '/' + TOTAL + ')');

// ── EVAL-002: Schema Compliance (ajv strict) ─────────────────────────────────
let run_hist_valid = 0, state_valid = 0;
try {
  const Ajv = require('ajv');
  const ajv = new Ajv({ allErrors: true, strict: false });
  const repoRoot = FD.replace(/\/.specs\/features\/[^/]+$/, '');
  const schemaDir = existsSync(repoRoot + '/schemas/run-history.schema.json') ? repoRoot + '/schemas' : '';
  if (existsSync('run-history.json')) {
    if (schemaDir) {
      const v = ajv.compile(JSON.parse(readFileSync(schemaDir + '/run-history.schema.json', 'utf8')));
      run_hist_valid = v(JSON.parse(readFileSync('run-history.json', 'utf8'))) ? 1 : 0;
    } else { JSON.parse(readFileSync('run-history.json', 'utf8')); run_hist_valid = 1; }
  }
  if (existsSync('state.json')) {
    if (schemaDir) {
      const v2 = ajv.compile(JSON.parse(readFileSync(schemaDir + '/state.schema.json', 'utf8')));
      state_valid = v2(JSON.parse(readFileSync('state.json', 'utf8'))) ? 1 : 0;
    } else { JSON.parse(readFileSync('state.json', 'utf8')); state_valid = 1; }
  }
} catch {
  try { JSON.parse(readFileSync('run-history.json', 'utf8')); run_hist_valid = 1; } catch {}
  try { JSON.parse(readFileSync('state.json', 'utf8')); state_valid = 1; } catch {}
}
const schema_score = (run_hist_valid + state_valid) / 2;
console.log('METRIC schema_compliance=' + schema_score.toFixed(4) + ' (run-hist=' + run_hist_valid + ' state=' + state_valid + ')');

// ── EVAL-003: State Alignment ─────────────────────────────────────────────────
let alignment_score = 0.0;
try {
  if (existsSync('state.md') && existsSync('state.json')) {
    const mdLines = readFileSync('state.md', 'utf8').split('\n');
    const sj = JSON.parse(readFileSync('state.json', 'utf8'));
    const matches = [
      mdExtract(mdLines, 'current_phase') === (sj.current_phase || ''),
      mdExtract(mdLines, 'status') === (sj.status || ''),
      mdExtract(mdLines, 'last_run_id') === (sj.last_run_id || '')
    ].filter(Boolean).length;
    alignment_score = matches / 3;
    console.log('METRIC state_alignment=' + alignment_score.toFixed(4) + ' (' + matches + '/3 fields aligned)');
  } else { console.log('METRIC state_alignment=0 (missing state.md or state.json)'); }
} catch(e) { console.log('METRIC state_alignment=0 (error: ' + e.message + ')'); }

// ── EVAL-004: Phase Coverage ──────────────────────────────────────────────────
let phase_score = 0.0;
try {
  if (existsSync('run-history.json')) {
    const rh = JSON.parse(readFileSync('run-history.json', 'utf8'));
    const actualPhases = [...new Set(rh.runs.map(r => r.phase))];
    const expected = ['SPECIFY','EVAL DEFINE','EXECUTE','VERIFY','REVIEW','REPORT','FINISH'];
    const matched = expected.filter(p => actualPhases.includes(p)).length;
    phase_score = matched / expected.length;
    console.log('METRIC phase_coverage=' + phase_score.toFixed(4) + ' (' + matched + '/' + expected.length + ' phases: ' + actualPhases.join(', ') + ')');
  } else { console.log('METRIC phase_coverage=0'); }
} catch(e) { console.log('METRIC phase_coverage=0 (error: ' + e.message + ')'); }

// ── EVAL-005: Evidence Quality ───────────────────────────────────────────────
let evidence_score = 0.0;
try {
  let totalRefs = 0, validRefs = 0, reviewDec = 0, reportRb = 0, stateRb = 0;
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
  if (existsSync('review.md')) { if (/decision|pass|rework|escalate/i.test(readFileSync('review.md', 'utf8'))) reviewDec = 1; }
  if (existsSync('report.md')) { if (/rollback/i.test(readFileSync('report.md', 'utf8'))) reportRb = 1; }
  if (existsSync('state.json')) { const sj = JSON.parse(readFileSync('state.json', 'utf8')); if (sj.rollback_target) stateRb = 1; }
  const evRatio = totalRefs > 0 ? validRefs / totalRefs : 0;
  const checks = (validRefs > 0 ? 1 : 0) + reviewDec + reportRb + stateRb;
  evidence_score = (evRatio + checks / 4) / 2;
  console.log('METRIC evidence_quality=' + evidence_score.toFixed(4) + ' (refs=' + validRefs + '/' + totalRefs + ' review=' + reviewDec + ' report_rb=' + reportRb + ' state_rb=' + stateRb + ')');
} catch(e) { console.log('METRIC evidence_quality=0 (error: ' + e.message + ')'); }

// ── EVAL-006: State Drift Detection ──────────────────────────────────────────
let drift_score = 1.0;
try {
  if (existsSync('state.md') && existsSync('state.json')) {
    const mdLines = readFileSync('state.md', 'utf8').split('\n');
    const sj = JSON.parse(readFileSync('state.json', 'utf8'));
    const drift_fields = ['feature_id','complexity','current_phase','status','owner_role','last_run_id','rollback_target'];
    let mismatches = 0;
    for (const key of drift_fields) {
      if (mdExtract(mdLines, key) !== (sj[key] || '').toString()) { mismatches++; console.log('  DRIFT: ' + key); }
    }
    drift_score = mismatches === 0 ? 1.0 : mismatches === 1 ? 0.5 : 0.0;
    console.log('METRIC state_drift=' + drift_score.toFixed(4) + ' (' + mismatches + ' mismatches)');
  } else { console.log('METRIC state_drift=0'); }
} catch(e) { console.log('METRIC state_drift=0 (error: ' + e.message + ')'); }

// ── EVAL-007: CI Pre-commit Hook ─────────────────────────────────────────────
let ci_hook_score = 0.0;
try {
  const repoRoot = FD.replace(/\/.specs\/features\/[^/]+$/, '');
  const hookPath = repoRoot + '/scripts/pre-commit-quality-check.sh';
  const hookExists = existsSync(hookPath);
  let hookExecutable = false;
  if (hookExists) { try { accessSync(hookPath, constants.X_OK); hookExecutable = true; } catch {} }
  ci_hook_score = (hookExists && hookExecutable) ? 1.0 : hookExists ? 0.5 : 0.0;
  console.log('METRIC ci_hook=' + ci_hook_score.toFixed(4) + ' (hook=' + (hookExists ? 'exists' : 'missing') + ' executable=' + hookExecutable + ')');
} catch(e) { console.log('METRIC ci_hook=0 (error: ' + e.message + ')'); }

// ── EVAL-008: Spec Structure Validation ──────────────────────────────────────
let spec_struct_score = 0.0;
try {
  const parts = { sections: 0, id_seq: 1, eval_refs: 1 };
  const requiredSections = ['Objective', 'Context', 'Scope', 'Requirements', 'Acceptance Criteria'];
  if (existsSync('spec.md')) {
    const specContent = readFileSync('spec.md', 'utf8');
    const foundSections = requiredSections.filter(s => specContent.includes('## ' + s) || specContent.includes('## ' + s.toLowerCase()));
    parts.sections = foundSections.length / requiredSections.length;
    const reqIds = [...new Set(specContent.match(/REQ-\d+/g) || [])];
    const reqNums = reqIds.map(id => parseInt(id.replace('REQ-', '')));
    if (!isSequential(reqNums)) parts.id_seq = 0;
  }
  if (existsSync('eval.md')) {
    const evalContent = readFileSync('eval.md', 'utf8');
    const evalIds = [...new Set(evalContent.match(/EVAL-\d+/g) || [])];
    const evalNums = evalIds.map(id => parseInt(id.replace('EVAL-', '')));
    if (!isSequential(evalNums)) parts.id_seq = 0;
  }
  if (existsSync('run-history.json') && existsSync('eval.md')) {
    const rh = JSON.parse(readFileSync('run-history.json', 'utf8'));
    const evalContent = readFileSync('eval.md', 'utf8');
    const evalIdSet = new Set(evalContent.match(/EVAL-\d+/g) || []);
    const allRhEvals = rh.runs.flatMap(r => r.related_eval_ids || []);
    const invalidRefs = allRhEvals.filter(id => !evalIdSet.has(id));
    parts.eval_refs = invalidRefs.length === 0 ? 1.0 : 0.5;
  }
  spec_struct_score = parts.sections * 0.4 + parts.id_seq * 0.4 + parts.eval_refs * 0.2;
  console.log('METRIC spec_structure=' + spec_struct_score.toFixed(4) + ' (sections=' + (parts.sections * 100).toFixed(0) + '% id_seq=' + parts.id_seq + ' eval_refs=' + parts.eval_refs + ')');
} catch(e) { console.log('METRIC spec_structure=0 (error: ' + e.message + ')'); }

// ── Composite Score ──────────────────────────────────────────────────────────
const quality_score = (
  artifact_score    * 0.15 +
  schema_score      * 0.15 +
  alignment_score   * 0.15 +
  drift_score       * 0.05 +
  phase_score       * 0.05 +
  evidence_score    * 0.15 +
  spec_struct_score  * 0.10 +
  ci_hook_score     * 0.20
);
console.log('');
console.log('METRIC quality_score=' + quality_score.toFixed(4));
console.log('--- breakdown ---');
console.log('  artifact_coverage  x 0.15 = ' + (artifact_score * 0.15).toFixed(4));
console.log('  schema_compliance  x 0.15 = ' + (schema_score * 0.15).toFixed(4));
console.log('  state_alignment    x 0.15 = ' + (alignment_score * 0.15).toFixed(4));
console.log('  state_drift        x 0.05 = ' + (drift_score * 0.05).toFixed(4));
console.log('  phase_coverage     x 0.05 = ' + (phase_score * 0.05).toFixed(4));
console.log('  evidence_quality   x 0.15 = ' + (evidence_score * 0.15).toFixed(4));
console.log('  spec_structure     x 0.10 = ' + (spec_struct_score * 0.10).toFixed(4));
console.log('  ci_hook            x 0.20 = ' + (ci_hook_score * 0.20).toFixed(4));
console.log('  TOTAL              = ' + quality_score.toFixed(4));
SCORE_EOF
