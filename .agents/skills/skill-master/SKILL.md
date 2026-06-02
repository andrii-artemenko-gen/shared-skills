---
name: skill-master
description: Use when working on skills development
---

# Agent Skills Mastery Guide

## Core Execution Protocol: Skill Repository Orchestration

When executing this guide, you must proactively orchestrate the lifecycle of all skills and architectural boundaries. You are the strict enforcer of repository standards.

- **Audit and Communicate:** Upon initialization, audit the project workspace. Check the inventory of existing skills, evaluate their operational statuses (e.g., active, failing, stale), and identify what requires updating. Communicate this status explicitly to stakeholders before initiating new configurations.
- **Enforce the Intake Interview:** Never draft a skill based on a vague request. Before writing _any_ skill definition, you must explicitly interrogate the user to gather the verifiable Definition of Done (DoD), negative constraints, and quantitative quality attributes.
- **Enforce Unambiguous Specifications:** Treat every skill instruction as a strict engineering specification. Pay intense attention to instruction definitions to ensure they are deterministic and impossible to interpret in more than one way.
- **Implement Continuous Learning:** Learn from previous mistakes. Every time a model deviates, fails a task, or misinterprets an instruction, you must automatically generate a new guardrail and append it to the relevant skill to prevent a recurrence.
- **Manage Architectural Complexity:** Recognize when a workflow outgrows a single-agent context. You must explicitly design and manage the handoff boundaries between specialized agents to prevent compounding errors.

## Core Primitives: Skills vs. Agents vs. Personas

Structure a skill as a directory containing a core definition file with YAML frontmatter, plus optional files for scripts, references, and templates. Scan the frontmatter at startup to decide what exists, but read the body only when the user request matches. Differentiate the three primitives and use them together in production setups:

- **Skills:** Handle the _how_. Scope strictly to a single domain and use a neutral voice. Define formats, checklists, and behaviors here. (Example: "Follow these steps for SEO")
- **Agents:** Handle the _what_. Scope strictly to a single domain and use a professional voice. (Example: "Run a security audit")
- **Personas:** Handle the _who_. Scope across domains and use a personality-driven voice. (Example: "Think like a startup CTO")

## Architectural Diagnostics: Single-Agent vs. Multi-Agent Fleet

Do not default to multi-agent architectures. Apply the following strict diagnostic rule before building:

- **The Diagnostic Check:** Ask the user: "Will a wrong decision compound faster than you can detect and roll it back?"
- **Single-Agent Path:** If the task is isolated (e.g., a local bug fix) and the rollback cost is strictly `< [Rollback Cost Threshold]`, build a standard single-agent skill.
- **Multi-Agent Path:** If the task involves architectural commitments across multiple phases, enforce a multi-agent fleet. Split the workflow into explicit roles (e.g., Planner, Spec-Writer, Implementer, Reviewer, Integrator).

## The Dos: Patterns That Scale

### 1. Treat Descriptions as Triggers, Not Documentation

Scan the description field at startup. Do not write descriptions that read like documentation, or the engine will not load the skill.

- Lead with verbs the agent will hear in user requests: run, write, debug, audit, refactor, generate, validate, deploy.
- Skip the passive "this skill helps with" framing entirely.
- Fire reliably by starting descriptions with "When the user asks to..." or "Run X when...".
- _Guardrail:_ Enforce the structure `[Action] when the user [Specific Condition]`.

### 2. Enforce Progressive Disclosure Across Files

Keep the always-loaded portion of the core definition file strictly under `[Always-Loaded Token Guardrail]`. Tell the agent what is in the directory, and command it to pull what it needs on demand.

- Store detailed signatures and edge cases in a `references/` directory.
- Store output templates in an `assets/` directory.
- Isolate deterministic logic that is not LLM-able in standalone files within a `scripts/` directory.

### 3. Make "Gotchas" the Highest-Signal Continuous Learning Section

Build a "Gotchas" section listing common failure modes the agent runs into to measurably improve accuracy.

- **Execute the Feedback Loop:** Every time the agent makes a mistake, misinterprets an instruction, or fails a prerequisite, immediately log the failure, draft a preventative guardrail, and append it to this section.
- Do not write Gotchas as documentation. Write them in the voice of a senior engineer pulling the agent aside to whisper "this will bite you."
- _Guardrail:_ Include specific limits like `[Rate Limit Request/Min Guardrail]` or `[Hidden Default CLI Behaviors]`.

### 4. Design Algorithmic Workflows with Unambiguous Notation

Structure the core logic of your skill as a well-described algorithm written in English. Eliminate any instruction that can be interpreted in multiple ways. Do not let the agent guess the order of operations or when to transition between states.

- **Use Ordered Step Progression:** Define explicit execution workflows using strictly numbered lists (Step 1, Step 2, Step 3). Explicitly state the trigger condition required to jump to the next step.
- **Implement "n" Notation for Loops:** Use an "Step n" notation to command the agent to continue a repetitive sequence. Define exactly when the sequence finishes (e.g., "Step n: Repeat Steps 2 and 3 until the remaining list item count equals 0").
- **Create Nested Sub-Programs:** Use nested ordered lists (e.g., 2.1, 2.2) to encapsulate complex logic. Treat each nested block as an independent sub-program with defined entry constraints and explicit exit conditions.

### 5. Define Deterministic Autonomous Goal Conditions

When a skill utilizes an autonomous looping or self-check mechanism, do not allow the working agent to arbitrarily grade its own homework. Enforce a strict goal definition formula to ensure completion is verifiable.

- **The Goal Formula:** Every self-checking skill must define completion as: `[Measurable End State] + [Verification Command] + [Protective Constraints] + [Iteration Limit]`.
- **Design for Evaluator Blindness:** The evaluation mechanism can only judge what appears in the execution transcript. Force the agent to run verification commands (e.g., test suites, linting) so the raw output lands in the transcript as hard evidence of success.

### 6. Enforce Explicit Handoff Checkpoints in Multi-Agent Workflows

Do not allow a single orchestrating system to make chained decisions across multiple agents silently. Visibility costs friction; pay the friction to eliminate detection lag.

- **Break the Boundary:** Encode agent handoff formats and review checklists as version-controlled skills.
- **Mandate Handoff Reviews:** Force each upstream agent to output a structured artifact. Force the system to pause and require human verification of that artifact before the downstream agent proceeds.

## The Don’ts: What Quietly Kills Skills

### 1. Split the "Do-Everything" Monolith

Do not build monoliths. A monolith is defined quantitatively as a skill that attempts to handle multiple independent operational domains simultaneously or exceeds the `[Always-Loaded Token Guardrail]`.

- **Measure Skill Cohesion Score (SCS):** Calculate cohesion using the formula: `SCS = (Number of actions mapping to the primary domain) / (Total number of discrete actions declared in the description)`.
- Ensure the SCS is strictly `>= [Minimum Cohesion Score Guardrail]`. If it drops below this threshold, split the skill into single-purpose components.

### 2. Never Rely on Implied Quality Standards

Do not use subjective targets like "make the code production-ready," "ensure it is clean," or "return proper validation errors." Evaluators cannot measure subjectivity.

- Decompose every qualitative requirement into an observable, testable specification (e.g., "Validation errors must return HTTP 400 with a JSON body containing errorCode, fields array, and a top-level message").

### 3. Never Omit Protective Constraints in Goal Definitions

Agents optimize purely for completion. Without strict boundaries, they will take destructive shortcuts (e.g., deleting a failing test to achieve a "100% pass rate" or deleting a feature to resolve a TODO comment).

- Always implement explicit negative constraints in your completion criteria: `[No functional code is removed to meet these criteria]`, `[No test files are deleted or skipped]`, `[Only modify files in <Target Directory>]`.

### 4. Eliminate Vague Descriptions

Do not use vague phrases like "Handles X" or "Provides Y functionality".

- Rewrite each description with strict conditions: when the user does what, on which inputs, producing what output.
- Read the description aloud: if it reads like a job listing, fix it. If it reads like a stage direction, ship it.

### 5. Eradicate Silent Assumptions

Do not allow agents to treat their own assumptions as ground truth.

- Implement explicit guardrails that forbid agents from acting on unverified assumptions regarding architecture, file locations, or framework choices.
- Force agents to surface assumptions at checkpoints and request explicit human confirmation.

## The Hard Rules: Absolute Dealbreakers

### 1. Never Include Credentials or Secrets

Treat every skill as a shareable artifact. Never hardcode paid API keys or secrets in the definition file. Reference environment variables and use Bring-Your-Own-Key (BYOK) patterns.

### 2. Never Override Safety Defaults Silently

Do not create security incidents by silently disabling permission prompts, bypassing code reviews, or ignoring rate limits. If the skill changes safety behavior, explicitly state so in the description and require explicit confirmation from the user in the body before running.

### 3. Verify Environment Prerequisites and Define Remediation Workflows

Do not assume the execution environment is perfectly configured.

- **Enforce Prerequisite Checks:** Instruct the agent to explicitly verify that all required dependencies—such as required CLI tools installed, necessary configuration files present, active protocol servers, or specific environment variables—are operational _before_ executing the main workflow.
- **Define Remediation Scenarios:** If a prerequisite is missing, the skill prompt must contain an explicit fallback scenario. Command the agent to halt the workflow immediately, inform the user of the missing dependency, and provide exact, step-by-step instructions on how to resolve it. Never allow the agent to proceed or hallucinate a workaround without the actual prerequisite.

## Agent Alert Rules: Scaling and Maintenance

You must actively monitor the repository and execute the following alert rules to maintain system integrity when scaling past `[High Volume Target]` skills:

### 1. Execute the Pre-Creation Intake Interview

- **Directive:** Prevent the creation of poorly defined skills by forcing an intake interview before any code or markdown is generated.
- **Agent Execution:** When a user requests a new skill, **halt the generation process immediately**. Output a mandatory questionnaire requesting the following parameters:
  1.  The exact, verifiable Definition of Done (e.g., "Script exits with 0", "Artifact is generated at path X").
  2.  Explicit negative constraints and restrictions (e.g., "Do not delete tests", "Do not modify files outside directory Y").
  3.  Quantitative quality attributes (e.g., "Maximum 200 lines of code", "Execution time under 2 seconds"—_reject subjective adjectives like "fast" or "clean"_).
      > `[COMPLIANCE ALERT: Intake Parameters Required. Before drafting this skill, you must provide: 1) A measurable Definition of Done, 2) Protective negative constraints, and 3) Quantitative quality attributes. Please provide these parameters to proceed.]`

### 2. Detect and Reject Unverifiable Completion Goals

- **Directive:** Prevent token burn caused by subjective or unmeasurable goal conditions.
- **Agent Execution:** Scan all completion triggers and goal definitions. If a definition lacks a strict verification command or relies on subjective adjectives ("clean," "proper"), halt the deployment and output:
  > `[COMPLIANCE ALERT: Unverifiable Goal Condition Detected. The evaluator cannot verify "[Subjective Term]" from the execution transcript. Rewrite using the exact formula: [Measurable End State] + [Verification Command] + [Protective Constraints].]`

### 3. Enforce Protective Constraints on Autonomous Loops

- **Directive:** Prevent destructive shortcuts by enforcing negative constraints on all autonomous execution workflows.
- **Agent Execution:** Audit self-checking loops for protective guardrails. If a loop is instructed to "fix" or "pass tests" without a constraint against deleting code or skipping tests, halt execution and output:
  > `[COMPLIANCE ALERT: Missing Protective Constraint. The agent may take destructive shortcuts to satisfy this goal. Add strict negative constraints (e.g., "No functional code or tests may be removed").]`

### 4. Detect and Flag Monolithic Architecture

- **Directive:** Prevent token bloat and lack of focus by enforcing strict cohesion limits and token limits.
- **Agent Execution:** On skill creation or modification, calculate the Skill Cohesion Score (SCS). Call `${CODEX_HOME:-$HOME/.codex}/scripts/measure_tokens.py` to track token usage. If the score is too low or token count exceeds `[Always-Loaded Token Guardrail]`, halt the operation and output:
  > `[COMPLIANCE ALERT: Monolith Detected. Cohesion Score is [SCS]. Token count is [Count]. Split this into single-purpose skills.]`

### 5. Optimize Discoverability to Prevent Duplication

- **Directive:** Write trigger phrases that are exhaustive enough to collide with your own search queries.
- **Agent Execution:** Scan the existing skill repository before generating or accepting a new skill definition. If a high semantic overlap in action verbs is detected, halt the creation process and output:
  > `[COMPLIANCE ALERT: Duplicate Workflow Risk. Skill [Existing Skill] already handles this function. Update [Existing Skill] instead of creating a new one.]`

### 6. Orchestrate Multi-Domain Tasks and Manage Operational Overhead

- **Directive:** Recognize when a single skill hits a coordination ceiling.
- **Agent Execution:** Count the distinct domains or tools added to a single definition file. If it exceeds the `[Coordination Ceiling Guardrail]`, halt expansion. Prompt the user to absorb the operational overhead of a multi-agent system and output:
  > `[COMPLIANCE ALERT: Coordination Ceiling Reached. Convert this into a multi-agent fleet. Encode the handoff structures between these sub-tasks as independent skills.]`

### 7. Audit for Version Drift

- **Directive:** Run evaluation tests after every major underlying AI model release. Tag failing skills for review and adjust description triggers to restore functionality.
- **Agent Execution:** Monitor the version block. If the skill has not been validated for the currently active AI model, tag it internally and output upon invocation:
  > `[COMPLIANCE ALERT: Version Drift. Last validated on [Date/Model]. Run a quick evaluation and adjust triggers if execution fails.]`

### 8. Large language models require direct and precious instructions

We should eliminate ability to interpret our instruction in other way then they are intended to be interpreted.
We want to eliminate the risk that our instruction gets lost or may be skipped.

Try to maximize amount of instructions by minimizing number of words. Ask yourself about the sense of each word in a sentence. Word is worth to be there is it adds meaning or semantic. Words added without intent to improve system should be removed.
Golden rule is to maximize amount of instructions and minimize number of words that are used to describe them.
Sometimes there may be special tricks used to describe some instructions.
For example, while we want the agent to use simpler lexicon, we may supply it with 3 paragraphs of which grammar to use and it will work, but the same result may be achieved by asking agent to use B2 English level.
At the same time while you want the agent to stick to the project architecture there is not enough to write to him to be a Senior developer, as it is not a standard, but the language level is standard.
The same may be told about some architecture and other things:
Yes architecture is a part of a standard, but it is more like a framework or recommendation, where also may be a place of deviation.
Try to use proper words and terminology so you will tweak vectors of the model to point to right sources. Try to understand what style of writing and expression is used in the domain you are working in and try to use proper words. Also pay attention to the level of expertise in the lexicon. While there is a general language that some specialists speak, they may express their thoughts differently based on the level of their experience. The difference between more and less experienced person is that more experienced person lexicon is extremely rich on using terminology, so you should aim to maximize this density in your prompts as well.

## Systemic Limitations: Active Mitigation Rules

Enforce structural guardrails to mitigate inherent ecosystem limitations. Execute these actions proactively:

### 1. Execute External Token Measurement Script

- **Directive:** Keep scripting tools strictly in standard libraries. Enforce token limits deterministically using an independent evaluation script rather than relying on LLM estimation.
- **Agent Execution:** Execute `${CODEX_HOME:-$HOME/.codex}/scripts/measure_tokens.py` to measure token limits accurately before loading. Pass the target definition file path as an argument. If the script fails, abort the loading process.

### 2. Combat Skill Rot Constantly

- **Directive:** Treat skills as living code, not static artifacts. Schedule regular audits to prevent your corpus from becoming stale and unresponsive.
- **Agent Execution:** Continuously monitor the version history timestamp. If the elapsed time exceeds the `[Staleness Threshold Guardrail]`, flag the skill and demand an audit, refactor, or deprecation.
