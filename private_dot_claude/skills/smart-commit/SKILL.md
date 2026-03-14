---
name: smart-commit
description: Create well-structured commits following Conventional Commits spec. Use this skill whenever the user wants to commit, make a commit, stage changes, or write a commit message. Automatically detects jj vs git, groups changed files into logical commits, and formats messages as `type(scope): description`. Trigger on: "commit", "make a commit", "commit my changes", "stage and commit", "write a commit", "commit this", "conventional commit", "split into commits".
allowed-tools: Bash(jj status:*),Bash(jj root:*),Bash(jj diff:*),Bash(git status:*),Bash(git diff:*)
---

# Smart Commit

## Current Repo State

- VCS: !`jj root >/dev/null 2>&1 && echo 'jj' || echo 'git'`
- Status: !`jj status 2>/dev/null || git status --short`

## Instructions

With the repo state above already loaded, proceed through these steps:

### 1. Group Files into Logical Commits

Analyze the changed files and group them into cohesive units. Each group should tell one story — a change that could stand alone as a reviewable unit.

The file list from `status` is usually enough to decide groupings — file names and paths convey a lot. If a grouping decision is genuinely ambiguous (e.g., two files with unrelated-looking names that might actually be coupled), run `jj diff <file>` or `git diff HEAD <file>` on just those files to clarify. Don't fetch the full diff upfront — it's expensive and rarely needed.

**Grouping heuristics:**

- Files that implement the same feature or fix belong together
- Test files belong with the code they test
- Config/dependency files (Cargo.toml, package.json, lock files) belong with the feature that required them
- Docs/spec files are often a separate commit unless tightly coupled to a code change
- Database migrations are always their own commit
- Refactors independent of feature work get their own commit

Don't over-split. Only split when changes truly serve different purposes.

Present the proposed grouping and confirm using `AskUserQuestion` before committing:

```
Proposed commits (N):

1. <type>(<scope>): <description>
   Files: <file-a>, <file-b>, ...

2. <type>(<scope>): <description>
   Files: <file-c>, <dir/>, ...
```

Use `AskUserQuestion` with options "Proceed" and "Make changes" (plus the default "Other" for free-text adjustments). Wait for the response before executing any commits. If the user requests changes, revise the grouping or messages and ask again.

### 2. Write Commit Messages

Format: `<type>(<scope>): <description>`

**Types:**
| Type | When to use |
|------|-------------|
| `feat` | New feature or capability |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `refactor` | Code restructure without behavior change |
| `test` | Adding or fixing tests |
| `chore` | Build, deps, tooling, config |
| `perf` | Performance improvement |
| `ci` | CI/CD pipeline changes |

**Scope:** Module or area affected. Lowercase, short (e.g., `auth`, `resolver`, `cli`). Omit if cross-cutting.

**Description:** Lowercase, imperative mood, no period, under 72 chars total on first line.

**Body** (optional): Explain _why_ if non-obvious. Wrap at 72 chars.

**Breaking changes:** Add `!` after type/scope and a `BREAKING CHANGE:` footer.

### 3. Execute Commits

**jj** — use `jj split [FILESETS]` to carve out files into a new parent commit, then describe each part:

```bash
# All files in one commit:
jj commit -m "<type>(<scope>): <description>"

# Two groups: split out the first, commit the rest
jj split -m "<type>(<scope>): <description>" <file-a> <file-b> ...
# @ now contains only the remaining files — commit them:
jj commit -m "<type>(<scope>): <description>"

# Three+ groups: chain splits, finish with commit
jj split -m "<type>: <description>" <file-a>
jj split -m "<type>(<scope>): <description>" <file-b> <file-c>
jj commit -m "<type>(<scope>): <description>"
```

`jj split` puts the selected files into a **new parent** commit and leaves the rest in `@`. The `-m` flag sets the message without opening an editor.

**git** — stage explicit paths (never `git add .` or `-A`):

```bash
git add <file-a> <file-b>
git commit -m "<type>(<scope>): <description>"

git add <file-c> <dir/>
git commit -m "<type>(<scope>): <description>"
```

Multi-line messages (both VCS):

```bash
jj commit -m "$(cat <<'EOF'
<type>(<scope>): <description>

<optional body explaining why>
EOF
)"
```

## Common Pitfalls

- Lock files belong with the feature that required them, not alone
- Don't bundle unrelated fixes — harder to revert or cherry-pick
- Omit body unless the _why_ isn't obvious from the diff
- Omit scope rather than invent a vague one like `misc`
- After `jj commit`, working copy is empty — commit is at `@-`
