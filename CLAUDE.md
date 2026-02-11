# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Claude Code plugin system (`knguyen0125`) providing multi-agent orchestration across four domains: engineering, executive, product, and general. Plugins contain **agents** (specialized AI roles) and **skills** (reusable techniques/reference guides).

## Architecture

```
.claude-plugin/marketplace.json    ← Plugin registry (lists all plugins)
plugins/
  <plugin-name>/
    .claude-plugin/plugin.json     ← Plugin metadata (name, version, author)
    agents/<name>.md               ← Agent definitions (YAML frontmatter + markdown)
    skills/<name>/SKILL.md         ← Skill definitions (+ optional supporting files)
```

**Agents vs Skills:**
- **Agent** = WHO + HOW. A role with constraints, model selection, and tool restrictions. Agents execute work.
- **Skill** = WHAT + WHEN. Domain knowledge, techniques, or reference material. Skills are loaded by agents or invoked directly.

**Key pattern: Builder & Validator.** Builder agents (Sonnet) write code, Validator agents (Opus) verify read-only. This separation enforces quality gates.

**Orchestration skills** (`plan-with-team`, `build`, `quick-plan`, `executive-discussion-with-team`, `product-brainstorm-with-team`) coordinate multiple agents using TaskCreate/TaskUpdate/TaskList/TaskGet tools. Plans are saved to `specs/` and executed with `/build <path>`.

## Plugins

| Plugin | Purpose | Agents | Key Skills |
|--------|---------|--------|------------|
| **engineering** | Code implementation workflows | builder (Sonnet), validator (Opus, read-only) | plan-with-team, quick-plan, build, commit, test-driven-development, security-analysis, design-postgres-tables |
| **executive** | C-suite strategic discussions | 7 executives (CEO, CTO, CPO, CMO, COO, CRO, CCO - all Opus) | executive-discussion-with-team |
| **product** | Feature brainstorming & research | ui-ux-specialist (Opus, read-only) | product-brainstorm-with-team |
| **general** | Meta-skills for authoring agents & skills | (none) | writing-agents, writing-skills |

## Conventions

- **Indentation:** 2 spaces (see `.editorconfig`)
- **Naming:** All kebab-case: plugin names, agent files, skill directories
- **Commits:** Conventional Commits with `@commitlint/config-conventional` types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`
- **Model selection:** haiku (simple/formulaic), sonnet (standard coding), opus (complex reasoning/judgment/review)
- **Plans output to:** `specs/<descriptive-name>.md`

## Agent Definition Format

```yaml
---
name: kebab-case-name
description: One-line description
model: [haiku|sonnet|opus]
color: [color]
skills: [optional list]
disallowedTools: [optional - e.g., Write, Edit, NotebookEdit for read-only]
---
```

Keep agents under 80 lines. Single responsibility (no "AND" in purpose). Use skills for domain knowledge rather than inlining.

## Skill Definition Format

```yaml
---
name: skill-name
description: "Use when [triggering conditions only - NEVER summarize workflow]"
argument-hint: "[args]"           # optional
model: opus                       # optional
disallowed-tools: Task            # optional
---
```

Description must start with "Use when..." and describe ONLY when to use it. If the description summarizes the workflow, Claude may follow the description instead of reading the skill body.

## Workflow: Planning → Building

1. **Full features:** `/plan-with-team "requirement"` → saves to `specs/` → `/build specs/<plan>.md`
2. **Bugs/small changes:** `/quick-plan "fix description"` → saves to `specs/` → `/build specs/<plan>.md`
3. **Quick-plan** accepts optional context plan: `/quick-plan "fix X" specs/original-plan.md`

## Key Enforcement Rules

- **TDD:** No production code without failing test first (`test-driven-development` skill)
- **Security:** OWASP A01-A10 walked explicitly, not pattern-matched (`security-analysis` skill)
- **Validation:** Validator agents are read-only (disallowedTools enforced)
- **Orchestrators never write code:** `plan-with-team` and `quick-plan` disable the Task tool to prevent execution
