---
name: skill-instruction-validation
description: Validate changed skill, agent, command, or prompt instructions with the runtime model that will execute them before Codex accepts or commits the change.
---

# Skill Instruction Validation

Use after semantic instruction edits. Semantic = changed rule, condition, label, tool, workflow step, guardrail, domain fact, heading reference, or list meaning. Treat edits as semantic until proven cosmetic.

Cosmetic skip requires all:
- spelling/punctuation/whitespace/comment-only diff
- no changed instruction sentence, heading, list order, label, tool, condition, or domain fact
- record `validation skipped: cosmetic only: <reason>`

## Runtime

Validate with the exact model/runtime that will execute the instruction.

- Claude Code -> `claude --print`
- Codex -> Codex subagent only when current policy and user request allow it; else exact repo/task Codex CLI/harness
- Other known runtime -> its real model/harness
- Shared prompt -> validate every runtime, or ask the user and record `single_runtime_approval: <who> approved <runtime> only because <reason>`
- Unknown runtime -> ask before validation
- Known but unavailable runtime -> record `validation_status: blocked` and ask before accepting/committing

## Workflow

1. State changed instruction, file, and intended behavior.
2. Identify consumer by path/frontmatter/tool config and `rg` references. If none or multiple, ask. Record `runtime_under_test: <runtime/model>`.
3. Choose that runtime's model. Never substitute a stronger/different model unless that runtime will use it.
4. Privately derive expected decisions from Step 1 if no decision table exists.
5. Prompt the model with changed file plus directly needed references only. Do not provide expected answers.
6. Ask for interpretation, scenario answers using real labels/statuses, and ambiguity/failure-risk notes.
7. Scenarios must cover: allowed success, required deferral/block, required failure, tempting invalid shortcut, boundary case.
8. Compare answers to expected decisions.
9. Wrong answer or risky ambiguity -> tighten instruction and rerun from Step 5.
10. Pass only when every scenario matches and no ambiguity can change a required decision, tool choice, output label, evidence rule, or commit gate.
11. Record evidence: `validation_status: passed|failed|blocked|skipped`, `runtime_under_test`, files, instruction, scenario count, decisions, ambiguity verdict, plus artifact path or inline summary.
12. Commit only after evidence exists or cosmetic skip is recorded. Do not commit artifacts unless requested.

## Claude CLI Pattern

```bash
claude --print --output-format json \
  --permission-mode bypassPermissions \
  --allowedTools "Read,Grep,Glob" \
  -- "Read <files>. Explain how you understand <instruction>. Then answer these scenarios with <labels>. Do not edit files."
```

## Pass Criteria

- The model restates the rule without changing its meaning.
- Scenario answers match expected status/decision labels.
- It rejects invalid shortcuts even when they sound convenient.
- It identifies no ambiguity that would let an invalid output ship.
