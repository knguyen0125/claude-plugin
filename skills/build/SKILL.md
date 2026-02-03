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

1. If no `PATH_TO_PLAN` is provied, STOP immediately and ask the user to provide it (AskUserQuestion).
2. Read and execute the plan at `PATH_TO_PLAN`. Think hard about the plan and implement it into the codebase.

## Report

* Present the `## Report` section of the plan.