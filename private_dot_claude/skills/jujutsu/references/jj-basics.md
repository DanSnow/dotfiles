# Jujutsu (jj) Basics

## Core Concepts

### Changes vs Commits
- **Change**: A snapshot of the working directory (like a draft)
- **Commit**: A finalized change with a message
- Every change gets a unique ID that persists across operations

### Bookmarks (Branches)
- **Bookmarks** are jj's equivalent to Git branches
- They point to specific changes and move automatically
- Must be **tracked** before pushing to remote

```bash
# Create a bookmark
jj bookmark create feat/my-feature

# Track for pushing (REQUIRED before first push)
jj bookmark track feat/my-feature --remote=origin

# Push bookmark
jj git push --bookmark feat/my-feature
```

### Working Copy (@)
- The `@` symbol represents the current working copy
- Always has a change ID, even without commits
- Can be empty (after commit) or contain modifications

### Revsets
Query language for selecting changes:
- `@` - current change
- `@-` - parent of current change
- `@--` - grandparent
- `main` - the main bookmark
- `::@` - all ancestors of current change

## Key Differences from Git

| Git | Jujutsu |
|-----|---------|
| Branch | Bookmark |
| Commit early | Commit when ready (auto-saves) |
| Staging area | No staging (all changes tracked) |
| Rebase workflow | Built-in conflict resolution |
| `git checkout` | `jj new` or `jj edit` |
| `git branch` | `jj bookmark` |

## Common Operations

### Status and Inspection
```bash
# View current state
jj status

# View history
jj log

# View specific change
jj show <change-id>

# View diff
jj diff
```

### Creating Changes
```bash
# Create new change based on current
jj new

# Create new change based on specific revision
jj new <rev>

# Edit existing change
jj edit <change-id>
```

### Committing
```bash
# Commit current changes
jj commit -m "message"

# Commit with multi-line message
jj commit -m "$(cat <<'EOF'
Title line

Body paragraph 1

Body paragraph 2
EOF
)"
```

### Bookmark Management
```bash
# List bookmarks
jj bookmark list

# Create bookmark
jj bookmark create <name>

# Delete bookmark
jj bookmark delete <name>

# Move bookmark to current change
jj bookmark set <name>

# Track remote bookmark (required before push)
jj bookmark track <name> --remote=origin
```

### Syncing with Remote
```bash
# Fetch changes
jj git fetch

# Push bookmark
jj git push --bookmark <name>

# Push all bookmarks
jj git push --all
```

## Important Notes

### Automatic Tracking
When you create a bookmark locally, it's NOT automatically tracked for pushing. You must run:
```bash
jj bookmark track <name> --remote=origin
```

### Empty Working Copy
After `jj commit`, the working copy becomes empty (new change with no modifications). This is normal - jj automatically creates a new change on top.

### Change IDs Persist
Unlike Git commit hashes, jj change IDs persist across operations like rebase. This makes it easier to track changes.
