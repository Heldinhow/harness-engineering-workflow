# Evidence Pack

## Purpose

Bundle verification evidence so it can be reviewed, traced, and freshness-checked as a unit.

## What an Evidence Pack Contains

An evidence pack is the set of all evidence refs accumulated during a run:

- command outputs captured during EXECUTE
- fresh verification output from VERIFY
- eval results referenced in REVIEW
- any inspection notes or structured review outputs

The pack lives in `run-history.json`'s `evidence_refs` arrays and is referenced by `review.md` and `finalize-report.md`.

## Evidence Pack Properties

1. **Timestamped**: each evidence ref should indicate when it was captured
2. **Fresh at capture**: evidence was captured after the last relevant change
3. **Complete**: all REQ-* in scope have corresponding EVAL-* evidence
4. **Organized**: evidence is grouped by what it proves, not by when it was captured

## Evidence Pack vs. Stale Evidence

When evidence in the pack becomes stale:

- Mark it in `stale_evidence_refs` in `state.json`
- Re-run the verification to produce fresh evidence
- Do not remove the stale ref — mark it stale so traceability is preserved

## Verifying the Evidence Pack

Before passing REVIEW:

1. Every REQ-* in scope has at least one piece of evidence in the pack
2. No evidence in the pack is marked stale
3. Evidence freshness timestamps are after the last relevant change
4. All evidence refs point to existing files

## Evidence Pack in Finalize

`finalize-report.md` should reference the complete evidence pack and confirm freshness for the final record.
