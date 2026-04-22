# Finalize Report: <feature>

## Summary
- Feature: <name>
- Outcome: <pass>
- Completed: <ISO 8601 timestamp>

## Scope Delivered
- <item>
- <item>

## Verification
- Evidence: <evidence ref>
- Notes: <notes>
- Evidence freshness: <current / stale — describe if changed since capture>

## Review
- Decision: <pass / rework / escalate>
- Findings: <findings>

## Evals
- Capability: <EVAL-001 result>
- Regression: <EVAL-002 result>
- Thresholds used: <thresholds>

## Evidence Freshness Check
Before finalizing, verify:
- [ ] All evidence_refs point to files that exist and reflect current state
- [ ] No relevant artifacts were modified after evidence was recorded
- [ ] If evidence is stale, either re-verify or update rollback target
- [ ] eval rerun triggers have not fired since evidence capture

## Residual Risks
- <risk or none>

## Pendings
- <known debt, follow-up, or deferred item — not hidden>
- <known debt, follow-up, or deferred item — not hidden>

## Handoff Notes
- <what the next session, agent, or human needs to know>
- <what the next session, agent, or human needs to know>

## Final Decision
- [x] pass
- [ ] rework
- [ ] escalate

## Example

### FINALIZE REPORT
## Summary
- Feature: example-feature
- Outcome: pass
- Completed: 2026-04-21T12:00:00Z

## Scope Delivered
- Updated AGENTS.md to new workflow index format
- Added docs/workflow/ and docs/roles/ structure
- Updated phase vocabulary across all canonical docs

## Verification
- Evidence: grep output confirming new phase vocabulary in docs
- Notes: All phase references updated, no old vocabulary in canonical docs
- Evidence freshness: current (captured after last doc edit)

## Review
- Decision: pass
- Findings: All gates green, evidence is fresh, state is aligned

## Evals
- Capability: EVAL-001 passed (vocabulary consistency confirmed)
- Regression: EVAL-002 passed (no old phase terms in canonical docs)
- Thresholds used: 0 old phase terms + all new terms present = pass

## Evidence Freshness Check
- [x] All evidence_refs point to existing files
- [x] No relevant artifacts modified after evidence capture
- [x] Evidence is fresh (timestamp: 2026-04-21T12:00:00Z)

## Residual Risks
- None identified

## Pendings
- REQ-007 (installer manifest update) deferred to next run
- Example features not yet migrated to new vocabulary

## Handoff Notes
- The repository now uses the new canonical workflow.
- New features should use the updated templates and docs.
- Old features (pre-migration) retain the old vocabulary and should be migrated incrementally.
- Installer manifest update (REQ-007) is the next pending item.

## Final Decision
- [x] pass
- [ ] rework
- [ ] escalate
