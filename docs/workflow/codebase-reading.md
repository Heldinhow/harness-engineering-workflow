# Codebase Reading

Broad codebase reading belongs to scoped subagents, not to the main Orchestrator.

## Small Scope The Orchestrator May Read Directly

The Orchestrator may read directly when the scope is clearly local, such as:

- one file
- one focused diff
- one feature artifact
- root framing docs
- memory docs

## When Delegation Is Required

Use `Codebase Reader` subagents when any of these are true:

- more than one functional area matters
- more than three files likely matter
- dependencies or boundaries need mapping
- impact analysis is required
- reading broadly would pollute the main agent's context

## Reader Contract

The reader gets:

- objective
- relevant `REQ-*`
- relevant `EVAL-*` when applicable
- allowed paths or bounded areas
- required artifacts to read
- ready definition
- done definition
- dependencies

The reader returns:

- relevant files
- technical summary
- expected impact
- risks
- dependencies
- objective recommendations

## Why This Matters

- keeps the main agent focused on orchestration decisions
- limits context blow-up
- improves resumability because the useful information is already filtered
- makes parallel investigation natural
