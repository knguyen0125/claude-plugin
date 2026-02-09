---
name: writing-agents
description: Use when creating or editing agent definition files (.md with YAML frontmatter) for Claude Code plugins, multi-agent systems, or custom agent types. Helps avoid bloat, scope creep, and misuse of agent vs skill boundaries.
---

# Writing Better Agents

## Overview

An agent is a **role with constraints**. It defines WHO the agent is, WHAT it can do, and HOW it reports back. Everything else belongs in skills, prompts, or the orchestrator.

**Core principle:** An agent should be as short as the builder agent (~50 lines). If your agent is over 80 lines, you're embedding domain knowledge that belongs elsewhere.

## When to Use

- Creating new agent definitions (`.md` files with YAML frontmatter)
- Editing existing agents
- Deciding whether something should be an agent, a skill, or orchestrator logic

## When NOT to Use

- Writing skills (use writing-skills)
- Writing orchestrator/skill logic (use plan-with-team)

## Agent Anatomy

```yaml
---
name: kebab-case-name
description: "One sentence. Start with action verb or role noun. Under 200 chars."
model: [haiku|sonnet|opus]  # Justify your choice
color: [color]
skills: [optional - only skills the agent needs]
disallowedTools: [optional - tools to restrict]
---
```

Body sections (in order):
1. **Purpose** (1-2 sentences) - Who you are, what you do
2. **Instructions** (bullet list) - Constraints and rules
3. **Workflow** (numbered list) - Steps to follow
4. **Report** (template) - How to report results

That's it. Four sections.

## The Five Rules

### 1. Single Responsibility

One agent = one job. Never combine build + review + validate.

| Need | Wrong | Right |
|------|-------|-------|
| Build + Review | "full-stack-developer" that does both | builder agent + code-reviewer agent |
| Execute + Validate | Agent that runs AND checks its own work | builder agent, then validator agent |
| Research + Decide | Agent that researches AND makes decisions | research agent reports to orchestrator who decides |

**If your agent has "AND" in its purpose, split it.**

### 2. Concise Body (Under 80 Lines)

The agent body tells the agent its role and constraints. It does NOT teach domain knowledge.

| Belongs in Agent | Belongs in Skill or Prompt |
|------------------|---------------------------|
| "You are a database migration agent" | PostgreSQL migration patterns |
| "Never execute DROP without confirmation" | SQL safety commands reference |
| "Use TaskUpdate when done" | How to write good SQL |
| "Report in this format: ..." | SWOT analysis framework |

**Test:** Would Claude already know this without being told? If yes, don't include it.

### 3. Justify Model Selection

| Model | Use When | Cost |
|-------|----------|------|
| **haiku** | Simple, formulaic tasks. No judgment needed. | Cheapest |
| **sonnet** | Standard coding, execution, research. | Mid |
| **opus** | Complex reasoning, review, validation, judgment calls. | Expensive |

State why you chose the model. "Needs complex judgment for safety-critical decisions" = opus. "Executes straightforward code changes" = sonnet.

### 4. Constrain Tool Access

If the agent shouldn't modify files, add `disallowedTools: Write, Edit, NotebookEdit`.
If the agent shouldn't spawn sub-agents, don't give it Task access.

**Default to restricting, not permitting.** An agent should have the minimum tools needed for its job.

### 5. Lean Report Template

Reports should be 10-15 lines max. Use this pattern:

```
## [Report Type]

**Task**: [description]
**Status**: [status]

**What was done**:
- [action 1]
- [action 2]

**Files changed**: [list]
**Verification**: [results]
```

Don't add placeholder tables, charts, or 20-section templates. The agent fills in what's relevant.

## Quick Reference: Agent vs Skill vs Orchestrator

| Put here | When... |
|----------|---------|
| **Agent** | Defining a role with constraints (who + rules + workflow + report) |
| **Skill** | Teaching domain knowledge, techniques, or reference material |
| **Orchestrator** | Coordinating multiple agents, managing dependencies, making decisions |

## Common Mistakes

**Embedding domain knowledge in agents:**
Don't put SQL examples, framework patterns, or analysis methodologies in agent files. Put them in skills and reference the skill in the agent's `skills:` frontmatter. If a relevant skill already exists, add it to the `skills:` list - don't re-teach its content.

**Forgetting to reference existing skills:**
Check what skills already exist before writing an agent. A database migration agent should reference `design_postgres_tables` in its `skills:` field. A builder should reference `test_driven_development`. The `skills:` field exists precisely to connect agents to domain knowledge without embedding it.

**Building monolithic "do everything" agents:**
When someone asks for "one agent that handles everything," push back. Specialized agents composed by an orchestrator always outperform monoliths because: separation of concerns enables independent testing, model selection per task optimizes cost, and constrained tools prevent accidents.

**Giant report templates:**
A 15-section report template with empty brackets wastes tokens every time the agent loads. Keep it under 15 lines. The agent knows how to write detailed reports when needed.

**Copying existing agent patterns without understanding:**
Reading existing agents is good. Producing something 3x longer "because my agent is more complex" is not. If builder does its job in 50 lines, your agent can too. Complexity belongs in skills, not agent definitions.

## Red Flags - STOP and Reconsider

- Agent body exceeds 80 lines
- Agent has "AND" in its purpose (build AND review, research AND decide)
- Agent includes SQL examples, code snippets, or domain-specific reference material
- Agent has no `disallowedTools` and no reasoning for full access
- Report template has more than 15 lines
- Model chosen without explicit justification
- Agent duplicates content from an existing skill

## Checklist

Before deploying an agent:
- [ ] Purpose is 1-2 sentences
- [ ] Body is under 80 lines
- [ ] Single responsibility (no "AND")
- [ ] Model justified (haiku/sonnet/opus with reasoning)
- [ ] disallowedTools considered (restrict by default)
- [ ] Domain knowledge in skills, not inline
- [ ] Existing skills referenced in `skills:` frontmatter
- [ ] Report template under 15 lines
- [ ] No duplication of existing agent capabilities
- [ ] Instructions use bullet list (not paragraphs)
- [ ] Workflow uses numbered list (not prose)
- [ ] Deliverable is ONE agent .md file (not supplementary docs)
