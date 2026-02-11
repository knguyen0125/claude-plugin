---
description: Use when fixing bugs, making small changes, or implementing minor features that don't require full team planning or brainstorming
argument-hint: "[prompt] [optional path-to-plan-for-context]"
model: opus
disallowed-tools: Task, EnterPlanMode
---

# Quick Plan

Lightweight alternative to `plan-with-team` for bugs, small features, and minor changes. Analyze the codebase, produce a concise plan, and save it. No extended brainstorming.

**Important**: STOP if calling model is not Sonnet or Opus

## Variables

* USER_PROMPT: $1
* CONTEXT_PLAN: $2 - (Optional) Path to an existing plan file for context (e.g., the original feature plan when fixing a bug in that feature)
* PLAN_OUTPUT_DIRECTORY: `specs/`

## Instructions

- **PLANNING ONLY**: Do NOT build, write code, or deploy agents. Your only output is a plan document saved to `PLAN_OUTPUT_DIRECTORY`.
- If no `USER_PROMPT` is provided, stop and ask the user to provide it.
- If `CONTEXT_PLAN` is provided, read it first to understand the broader context before analyzing.
- Determine the task type: `fix` | `enhancement` | `chore` | `refactor`
- Analyze the codebase directly (no subagents) to understand the relevant code, patterns, and architecture.
- If something is truly ambiguous (e.g., multiple possible root causes, unclear which component to change), ask ONE clarifying question. Otherwise, proceed directly to producing the plan.
- Generate a descriptive, kebab-case filename and save to `PLAN_OUTPUT_DIRECTORY/<filename>.md`.
- Keep it concise. This is for small, focused work.

## Workflow

1. **Read Context** (if CONTEXT_PLAN provided) - Understand the broader plan/feature this change relates to.
2. **Analyze** - Read relevant files, understand the problem, identify the fix/change needed.
3. **Clarify** (only if truly ambiguous) - Ask ONE question max. If reasonably clear, skip this.
4. **Plan** - Write the plan following the Plan Format below.
5. **Save & Report** - Save to `PLAN_OUTPUT_DIRECTORY/<filename>.md` and provide the report.

## Plan Format

IMPORTANT: Replace `<requested content>` with actual content. Anything NOT in angle brackets should appear exactly as written.

```md
# Plan: <task name>

## Task Description
<describe the task based on prompt>

## Objective
<what will be accomplished when done>

## Relevant Files
<list files relevant to the task with bullet points explaining why>

### New Files
<if any new files needed, list them here. Remove this section if none.>

## Team Orchestration

- You operate as the team lead and orchestrate the team to execute the plan.
- You're responsible for deploying the right team members with the right context to execute the plan.
- IMPORTANT: You NEVER operate directly on the codebase. You use `Task` and `Task*` tools to deploy team members to to the building, validating, testing, deploying, and other tasks.
  - This is critical. You're job is to act as a high level director of the team, not a builder.
  - You're role is to validate all work is going well and make sure the team is on track to complete the plan.
  - You'll orchestrate this by using the Task* Tools to manage coordination between the team members.
  - Communication is paramount. You'll use the Task* Tools to communicate with the team members and ensure they're on track to complete the plan.
- Take note of the session id of each team member. This is how you'll reference them.

### Team Members

- Builder
  - Name: <descriptive name, e.g., "fix-builder">
  - Role: <focused role description>
  - Agent Type: engineering:builder
  - Resume: true
- Validator
  - Name: <descriptive name, e.g., "fix-validator">
  - Role: Verify the fix meets acceptance criteria
  - Agent Type: engineering:validator
  - Resume: false

## Step by Step Tasks

- IMPORTANT: Execute every step in order, top to bottom. Each task maps directly to a `TaskCreate` call.
- Before you start, run `TaskCreate` to create the initial task list that all team members can see and execute.

### 1. <Implementation Task Name>
- **Task ID**: <unique-kebab-case>
- **Depends On**: none
- **Assigned To**: <builder name>
- **Agent Type**: engineering:builder
- **Parallel**: false
- **Skills Required**: <list or "none">
- **Acceptance Criteria**:
  - <specific, measurable criterion 1>
  - <specific, measurable criterion 2>
- <specific action>
- <specific action>

<add more implementation tasks only if needed - keep minimal>

### N. Validate Changes
- **Task ID**: validate-all
- **Depends On**: <all previous Task IDs>
- **Assigned To**: <validator name>
- **Agent Type**: engineering:validator
- **Parallel**: false
- **Skills Required**: <list or "none">
- **Acceptance Criteria**:
  - All prior task acceptance criteria verified
  - <any additional validation criteria>
- Run validation commands
- Verify acceptance criteria met

## Acceptance Criteria

### Task-Level Acceptance Criteria
- **Builder tasks**: Code compiles, fix works, tests pass
- **Validator tasks**: All task-level criteria from prior tasks verified

### Plan-Level Acceptance Criteria
<list specific, measurable criteria for the overall change>

## Validation Commands
<list specific commands to validate the work>

## Notes
<optional: context, edge cases, or considerations. Remove if none.>
```

## Report

After saving the plan, provide:

```
✅ Quick Plan Created

File: PLAN_OUTPUT_DIRECTORY/<filename>.md
Topic: <brief description>
Changes:
- <change 1>
- <change 2>

Team:
- <builder name> → <role>
- <validator name> → validation

When ready: /build <path-to-plan>
```
