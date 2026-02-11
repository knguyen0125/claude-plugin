---
name: commit
description: Use when committing changes to git, creating commit messages, or the user asks to commit
argument-hint: "[optional commit message override]"
allowed-tools: Bash(git add:*) Bash(git commit:*) Bash(git status:*) Bash(git diff:*) Bash(git log:*)
---

# Commit

Create git commits following [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) with [@commitlint/config-conventional](https://github.com/conventional-changelog/commitlint/tree/master/%40commitlint/config-conventional) rules.

## Variables

OVERRIDE_MESSAGE: $ARGUMENTS - (Optional) If provided, use as the commit message instead of generating one. Still validate it against the format rules below.

## Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## Rules

### Header (max 100 chars total)
- **type** (required): One of `build`, `chore`, `ci`, `docs`, `feat`, `fix`, `perf`, `refactor`, `revert`, `style`, `test`
- **scope** (optional): Noun in parentheses describing the section, e.g. `fix(parser):`
- **description** (required): Imperative, present tense ("add" not "added"). Lowercase first letter. No period at end.

### Body (optional)
- Blank line after header
- Max 100 chars per line
- Explain **what** and **why**, not how

### Footer (optional)
- Blank line after body
- `BREAKING CHANGE: <description>` for breaking changes
- Or append an exclamation mark after type/scope, e.g., `feat!:` or `feat(api)!:`
- Other trailers: `Reviewed-by:`, `Refs:`, `Closes #123`

## Type Reference

| Type | When |
|------|------|
| `feat` | New feature for the user |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `style` | Formatting, semicolons, whitespace (no logic change) |
| `refactor` | Code change that neither fixes a bug nor adds a feature |
| `perf` | Performance improvement |
| `test` | Adding or correcting tests |
| `build` | Build system or external dependencies (npm, pip, gradle) |
| `ci` | CI configuration (GitHub Actions, Jenkins, CircleCI) |
| `chore` | Maintenance tasks, tooling, config (no src/test change) |
| `revert` | Reverts a previous commit |

## Workflow

1. Run `git status` and `git diff --cached` (and `git diff` if nothing staged) to understand changes.
2. Run `git log --oneline -10` to see recent commit style for consistency.
3. **Group related files into logical commits.** Do NOT lump all changes into one commit. Each commit should represent ONE logical change:
   - Group by purpose: a bug fix and its test go together; a new feature and its docs go together
   - Separate unrelated changes: config updates, refactors, and new features are separate commits
   - When in doubt, split. Smaller focused commits > one large commit.
4. For each logical group, generate a commit message:
   - If OVERRIDE_MESSAGE is provided, validate it against format rules and use it (applies to first/only commit).
   - Pick the most accurate **type** from the table above
   - Add **scope** if changes are scoped to a specific module/component
   - Write a concise **description** in imperative mood
   - Add **body** only if the "why" isn't obvious from the description
   - Add `BREAKING CHANGE` footer if applicable
5. Stage only the files for the current logical group (`git add <specific files>` - never `git add .` or `git add -A`).
6. Commit each group using a HEREDOC, one at a time. Do NOT ask for approval — proceed directly:
```bash
git commit -m "$(cat <<'EOF'
<type>(scope): description

optional body

optional footer
EOF
)"
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| `Fix bug` | `fix: resolve null pointer in auth middleware` - lowercase, imperative |
| `feat: Added new feature.` | `feat: add user profile page` - no past tense, no period |
| Header > 100 chars | Move details to body |
| `git add .` | Stage specific files to avoid secrets/artifacts |
| Wrong type | `style` is formatting only, `refactor` changes code structure, `chore` is tooling |
| `fix: stuff` | Be specific: `fix(auth): handle expired token redirect` |
| One giant commit with unrelated changes | Split: `fix(auth): ...` then `docs: ...` then `chore: ...` as separate commits |
