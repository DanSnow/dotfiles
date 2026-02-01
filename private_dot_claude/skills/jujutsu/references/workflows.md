# Common Jujutsu Workflows

## Feature Development Workflow

### Starting New Work
```bash
# 1. Check status
jj status

# 2. Create and track bookmark
jj bookmark create feat/my-feature
jj bookmark track feat/my-feature --remote=origin

# 3. Make changes and commit when ready
# (work on code...)
jj commit -m "feat: add new feature"

# 4. Push
jj git push --bookmark feat/my-feature
```

### Quick Commit and PR
For rapid iteration using mask:
```bash
# Commit → bookmark → track → push → PR (all in one)
mask --maskfile ~/.claude/skills/jujutsu/maskfile.md commit-and-pr \
  --bookmark feat/my-feature \
  --message "feat: description" \
  --title "PR Title" \
  --body "PR Body"

# Or with alias (if configured)
jj-mask commit-and-pr -b feat/my-feature -m "feat: description" -t "PR Title" --body "PR Body"
```

## Iterating on a Feature

### Adding More Changes
```bash
# After committing, working copy is empty (@)
# Make more changes and commit again
jj commit -m "feat: additional work"

# Push updates
jj git push --bookmark feat/my-feature
```

### Amending Last Commit
```bash
# Edit the previous commit
jj edit @-

# Make changes
# ...

# Commit the amendments
jj commit --amend

# Return to tip
jj new
```

### Fixing Earlier Commits
```bash
# Edit specific change
jj edit <change-id>

# Make fixes
# ...

# Commit the fix
jj commit --amend

# Return to latest
jj new
```

## Syncing with Remote

### Fetching Updates
```bash
# Fetch from origin
jj git fetch

# View fetched changes
jj log

# Rebase if needed
jj rebase -d main
```

### Resolving Conflicts
Jj handles conflicts differently - they're first-class citizens:
```bash
# Conflicts appear in working copy with markers
# Edit files to resolve

# After resolving, commit
jj commit -m "resolve conflicts"
```

## Cleaning Up

### Deleting Local Bookmarks
```bash
# Delete bookmark
jj bookmark delete feat/old-feature

# Delete multiple
jj bookmark delete feat/feature-1 feat/feature-2
```

### Syncing After Remote Delete
```bash
# Fetch to sync remote state
jj git fetch

# Delete tracking for removed remote bookmarks
jj bookmark forget feat/merged-feature
```

## Common Patterns

### Pattern: Create PR from Current Work
```bash
# 1. Ensure changes are committed
jj commit -m "message"

# 2. Create and track bookmark
jj bookmark create feat/name
jj bookmark track feat/name --remote=origin

# 3. Push and create PR
jj git push --bookmark feat/name
gh pr create --head feat/name --base main --title "Title"
```

### Pattern: Multiple Commits on One Branch
```bash
# Commit 1
jj commit -m "part 1"

# Commit 2 (working copy is now new change on top)
jj commit -m "part 2"

# Commit 3
jj commit -m "part 3"

# All commits are on the same bookmark if it existed before commit 1
jj git push --bookmark feat/my-feature
```

### Pattern: Working on Multiple Features
```bash
# Feature A
jj bookmark create feat/feature-a
# work, commit...

# Switch to Feature B
jj new main  # Start from main
jj bookmark create feat/feature-b
# work, commit...

# Switch back to Feature A
jj edit <change-id-from-feature-a>
# continue work...
```

### Pattern: Stashing Work (Not Needed!)
Unlike Git, jj doesn't need stashing:
```bash
# Just create a new change
jj new

# Or edit a different change
jj edit <other-change>

# Your uncommitted work stays in its change
# Switch back anytime with: jj edit <original-change>
```

## Troubleshooting

### "Not on any branch" error
This happens in Git-based tools when working copy isn't attached to a bookmark:
```bash
# Create bookmark at current change
jj bookmark create feat/my-work

# Or move existing bookmark
jj bookmark set feat/my-work
```

### Bookmark not tracking remote
```bash
# Track it
jj bookmark track feat/my-feature --remote=origin

# Then push
jj git push --bookmark feat/my-feature
```

### Lost changes after commit
This is normal! After `jj commit`, working copy becomes a new empty change. Your committed change still exists at `@-`.

```bash
# View your commit
jj show @-

# Continue working on new change (normal workflow)
```
