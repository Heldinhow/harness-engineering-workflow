# State: <feature>

## Current Phase
<INTAKE / SPECIFY / DESIGN / TASKS / EVAL DEFINE / EXECUTE / VERIFY / REVIEW / REPORT / FINISH>

**IMPORTANT**: This MUST match state.json "current_phase"

## Status
<not_started / in_progress / blocked / done>

## Complexity
<small / medium / large / complex>

## Pending Gate
<gate waiting to clear>

## Owner
- Role: <orchestrator | codebase-reader | spec-agent | design-agent | eval-agent | execution-agent | reviewer>
- Id: <session or agent id>

## Open Issues
- <item>

## Latest Evidence
- <evidence ref>

## Stale Evidence
- <stale evidence ref or none>

## Next Step
- <next step>

## Rollback Target
- <specific phase name — NOT "earlier" or "previous">

**Rollback Checklist:**
- [ ] Specific phase named (e.g., "EXECUTE") not vague ("earlier")
- [ ] Consistent with state.json "rollback_target"
- [ ] Documented in run-history.json for this gate
