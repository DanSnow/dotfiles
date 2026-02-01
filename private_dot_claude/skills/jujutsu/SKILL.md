---
name: jujutsu
description: Jujutsu (jj) version control workflows and GitHub integration. Use when working with jj commands, creating commits with bookmarks, pushing to remote, creating PRs, or when the user mentions "jj", "jujutsu", "bookmark", or version control operations that involve jj instead of git. Also use when encountering jj-specific concepts like changes vs commits, bookmark tracking requirements, or when troubleshooting jj/GitHub integration issues.
---

# Jujutsu (jj) Workflows

Jujutsu is a next-generation version control system that improves on Git's design. This skill provides patterns for common workflows.

## Quick Reference

### Essential Commands
```bash
# Status and inspection
jj status              # View current state
jj log                 # View history
jj diff                # View changes

# Committing
jj commit -m "message"

# Bookmark management
jj bookmark create <name>
jj bookmark track <name> --remote=origin  # Required before push!
jj git push --bookmark <name>
```

### Common Workflow
```bash
# 1. Commit changes
jj commit -m "feat: description"

# 2. Create and track bookmark
jj bookmark create feat/my-feature
jj bookmark track feat/my-feature --remote=origin

# 3. Push
jj git push --bookmark <name>

# 4. Create PR
gh pr create --head feat/my-feature --base main --title "Title"
```

## Automated Workflows with Mask

This skill includes a `maskfile.md` with automated workflows. [Mask](https://github.com/jacobdeichert/mask) is a task runner that uses markdown files.

### Installation
```bash
brew install mask
```

### Usage

All mask commands require pointing to the maskfile in the skill directory:

```bash
mask --maskfile ~/.claude/skills/jujutsu/maskfile.md <command>
```

**Tip:** Create a shell alias for convenience:
```bash
alias jj-mask='mask --maskfile ~/.claude/skills/jujutsu/maskfile.md'
```

### Complete Workflow: Commit and PR
```bash
mask --maskfile ~/.claude/skills/jujutsu/maskfile.md commit-and-pr \
  --bookmark feat/add-auth \
  --message "feat(auth): implement user authentication" \
  --title "Add user authentication" \
  --body "Implements JWT-based auth"
```

This automates: commit → create bookmark → track → push → create PR.

### Individual Tasks
```bash
# Using full path
mask --maskfile ~/.claude/skills/jujutsu/maskfile.md commit -m "message"
mask --maskfile ~/.claude/skills/jujutsu/maskfile.md create-bookmark -n feat/name
mask --maskfile ~/.claude/skills/jujutsu/maskfile.md push -b feat/name
mask --maskfile ~/.claude/skills/jujutsu/maskfile.md status

# Or with alias
jj-mask commit -m "message"
jj-mask create-bookmark -n feat/name
jj-mask push -b feat/name
jj-mask status
```

See `maskfile.md` for all available commands and options.

## Key Concepts

### Bookmarks Must Be Tracked
**Critical:** Bookmarks are NOT automatically tracked for remote push. Always run:
```bash
jj bookmark track <name> --remote=origin
```

Without this, `jj git push` will fail with "Refusing to create new remote bookmark".

### Changes vs Commits
- **Change**: A snapshot (like a draft), persists across operations
- **Commit**: Finalized change with message
- After commit, working copy becomes empty (new change on top)

### The @ Symbol
- `@` = current working copy
- `@-` = parent of current
- `@--` = grandparent

## Common Patterns

### Multi-line Commit Messages
```bash
jj commit -m "$(cat <<'EOF'
feat(scope): title

Detailed explanation.

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
EOF
)"
```

### Creating PR with Body
```bash
gh pr create \
  --head feat/name \
  --base main \
  --title "Title" \
  --body "$(cat <<'EOF'
## Summary
Description

## Changes
- Item 1
- Item 2
EOF
)"
```

### Conventional Commits
Format: `<type>(<scope>): <subject>`

Types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`

Example: `feat(api): add new endpoint`

## Reference Documentation

For detailed information, see:
- **[jj-basics.md](references/jj-basics.md)** - Core concepts, differences from Git
- **[workflows.md](references/workflows.md)** - Feature development patterns
- **[github-integration.md](references/github-integration.md)** - PR creation, bookmark naming

## Troubleshooting

### "Refusing to create new remote bookmark"
```bash
jj bookmark track <name> --remote=origin
jj git push --bookmark <name>
```

### "not on any branch" (GitHub CLI)
```bash
jj bookmark create feat/my-work
jj bookmark track feat/my-work --remote=origin
```

### Changes Disappeared After Commit
Normal behavior! Your commit is at `@-`. Working copy is now empty (`@`), ready for next change.

```bash
jj show @-  # View your commit
```
