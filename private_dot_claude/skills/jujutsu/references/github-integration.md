# GitHub Integration with Jujutsu

## PR Creation Workflow

### Standard PR Creation
```bash
# 1. Commit changes
jj commit -m "feat: add feature"

# 2. Create and track bookmark
jj bookmark create feat/my-feature
jj bookmark track feat/my-feature --remote=origin

# 3. Push to remote
jj git push --bookmark feat/my-feature

# 4. Create PR with gh CLI
gh pr create \
  --head feat/my-feature \
  --base main \
  --title "feat: add feature" \
  --body "Description..."
```

### Using Mask Automation
The `maskfile.md` combines all steps:
```bash
# Full workflow: commit → bookmark → track → push → PR
mask --maskfile ~/.claude/skills/jujutsu/maskfile.md commit-and-pr \
  --bookmark feat/my-feature \
  --message "feat: add feature

Detailed commit message body..." \
  --title "PR Title" \
  --body "PR Body"

# Or with alias (if configured: alias jj-mask='mask --maskfile ~/.claude/skills/jujutsu/maskfile.md')
jj-mask commit-and-pr -b feat/my-feature -m "feat: add feature" -t "PR Title" --body "PR Body"
```

## Common Patterns

### Multi-line Commit Messages
```bash
jj commit -m "$(cat <<'EOF'
feat(scope): short title

Detailed explanation of changes.

Why this change is needed.

Co-Authored-By: Name <email>
EOF
)"
```

### Creating PR with Detailed Body
```bash
gh pr create \
  --head feat/name \
  --base main \
  --title "Title" \
  --body "$(cat <<'EOF'
## Summary
Brief description

## Changes
- Change 1
- Change 2

## Testing
How to test
EOF
)"
```

## Conventional Commits

Follow Conventional Commits format for consistency:

**Format:** `<type>(<scope>): <subject>`

**Types:**
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation changes
- `refactor` - Code refactoring
- `test` - Test updates
- `chore` - Build, deps, config

**Examples:**
```bash
jj commit -m "feat(api): add new endpoint"
jj commit -m "fix(auth): resolve token expiration"
jj commit -m "docs(readme): update setup instructions"
```

## Co-authoring with Claude

When working with Claude Code, add co-authoring credit:
```bash
jj commit -m "feat: description

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

## Handling PR Updates

### Adding More Commits
```bash
# Make changes
jj commit -m "address review feedback"

# Push updates
jj git push --bookmark feat/my-feature
```

### Amending Last Commit
```bash
# Edit previous commit
jj edit @-

# Make changes
jj commit --amend

# Force push (jj handles this safely)
jj git push --bookmark feat/my-feature
```

## Bookmark Naming Conventions

Use clear, descriptive bookmark names:

**Good:**
- `feat/add-user-auth`
- `fix/memory-leak`
- `refactor/api-cleanup`
- `docs/setup-guide`

**Avoid:**
- `my-branch`
- `temp`
- `test-1`
- `fix`

## Troubleshooting GitHub Integration

### "not on any branch" Error
GitHub CLI expects a Git branch. Create a bookmark:
```bash
jj bookmark create feat/my-work
jj bookmark track feat/my-work --remote=origin
```

### Bookmark Not Showing on Remote
Ensure bookmark is tracked:
```bash
jj bookmark track feat/name --remote=origin
jj git push --bookmark feat/name
```

### PR Shows Wrong Commits
Check bookmark points to correct change:
```bash
# View bookmark location
jj log

# Move bookmark if needed
jj bookmark set feat/name -r <correct-change-id>
jj git push --bookmark feat/name --force
```