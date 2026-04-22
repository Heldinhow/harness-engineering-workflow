# Subagent Boundaries

## Purpose

Use subagents as a context firewall to keep the main Orchestrator focused and prevent context pollution.

## The Firewall Principle

The Orchestrator should never absorb raw context from broad codebase reading. Instead, it delegates reading to scoped subagents who return only filtered, structured outputs. This keeps the Orchestrator's context narrow and decision-quality.

## When to Delegate

Delegate to a subagent when any of these are true:

- more than one functional area matters
- more than three files likely matter
- module boundaries or dependencies are unclear
- impact analysis is needed
- broad rereading would pollute the main context

## What the Orchestrator May Read Directly

Without delegation:

- the user request
- feature artifacts under `.specs/features/<feature>/`
- root framing docs like `README.md` and `AGENTS.md`
- `memory/project/*` and `memory/codebase/*`
- a clearly local scope such as one file or one tight diff

## Minimum Delegation Contract

Every delegated task should include:

- objective
- relevant REQ-*
- relevant EVAL-* when applicable
- allowed paths or bounded areas
- required artifacts
- ready definition
- done definition
- dependencies

## Filtered Delegation Output

Every delegation should return only:

- relevant files
- technical summary
- expected impact
- risks
- dependencies
- objective recommendations

## What Subagents Must Not Return

- raw transcript of everything read
- files outside the allowed paths
- opinions not requested by the objective
- context for the Orchestrator to synthesize — only the synthesized result

## Consolidation Rules

- Raw findings belong in delegated artifacts.
- The Orchestrator updates state and chooses next phase.
- Do not pass raw context to the Orchestrator — pass only the filtered result.
