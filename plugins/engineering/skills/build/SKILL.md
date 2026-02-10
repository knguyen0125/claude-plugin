---
name: build
description: Implement the plan
argument-hint: path-to-plan
---

# Build

Follow the `Workflow` to implement the `PATH_TO_PLAN` then `Report` the completed work.

## Variables

PATH_TO_PLAN: $ARGUMENTS

## Workflow

1. If no `PATH_TO_PLAN` is provided, STOP immediately and ask the user to provide it (AskUserQuestion).
2. Read and execute the plan at `PATH_TO_PLAN`. Follow the plan's Team Orchestration section and Step by Step Tasks.
3. For each task, when deploying agents:
   - Check the **Skills Required** field in the task definition
   - If skills are specified, include explicit instructions in the agent's prompt to use those skills
   - Example: If "Skills Required: design-postgres-tables" → tell the agent "Use the /design-postgres-tables skill to..."
   - Example: If "Skills Required: security-analysis" → tell the agent "After implementation, use the /security-analysis skill to review your code..."
4. Monitor task progress and coordinate team members according to the plan.

## Report

* Present the `## Report` section of the plan.