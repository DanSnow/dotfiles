# Jujutsu Workflows

Common jujutsu workflows automated with mask.

## commit-and-pr (bookmark) (message) (title) (body?)

> Complete workflow: commit → create bookmark → track → push → create PR

Automates the entire process of committing changes, creating a bookmark, pushing to remote, and creating a GitHub pull request.

**OPTIONS**
* bookmark
  * flags: -b, --bookmark
  * type: string
  * desc: Bookmark name (e.g., feat/my-feature)
* message
  * flags: -m, --message
  * type: string
  * desc: Commit message (supports multi-line)
* title
  * flags: -t, --title
  * type: string
  * desc: Pull request title
* body
  * flags: --body
  * type: string
  * desc: Pull request body (optional, markdown supported)

**EXAMPLE**
```bash
mask commit-and-pr \
  --bookmark feat/add-auth \
  --message "feat(auth): implement user authentication" \
  --title "Add user authentication" \
  --body "Implements JWT-based auth"
```

~~~bash
set -e

echo "📝 Committing changes..."
jj commit -m "$message"

echo "🔖 Creating bookmark: $bookmark"
jj bookmark create "$bookmark"

echo "📍 Tracking bookmark..."
jj bookmark track "$bookmark" --remote=origin

echo "⬆️  Pushing to remote..."
jj git push --bookmark "$bookmark"

echo "🔗 Creating PR..."
if [ -n "$body" ]; then
  gh pr create --head "$bookmark" --base main --title "$title" --body "$body"
else
  gh pr create --head "$bookmark" --base main --title "$title"
fi

echo "✅ Complete! PR created."
~~~

## commit (message)

> Commit changes with a message

Commits the current working copy changes.

**OPTIONS**
* message
  * flags: -m, --message
  * type: string
  * desc: Commit message

~~~bash
jj commit -m "$message"
echo "✅ Changes committed"
~~~

## create-bookmark (name)

> Create and track a bookmark

Creates a new bookmark at the current change and tracks it for remote pushing.

**OPTIONS**
* name
  * flags: -n, --name
  * type: string
  * desc: Bookmark name

~~~bash
set -e
echo "🔖 Creating bookmark: $name"
jj bookmark create "$name"

echo "📍 Tracking for remote..."
jj bookmark track "$name" --remote=origin

echo "✅ Bookmark created and tracked"
~~~

## push (bookmark)

> Push bookmark to remote

Pushes the specified bookmark to origin.

**OPTIONS**
* bookmark
  * flags: -b, --bookmark
  * type: string
  * desc: Bookmark name to push

~~~bash
jj git push --bookmark "$bookmark"
echo "✅ Pushed to remote"
~~~

## create-pr (bookmark) (title) (body?)

> Create a pull request

Creates a GitHub pull request for the specified bookmark.

**OPTIONS**
* bookmark
  * flags: -b, --bookmark
  * type: string
  * desc: Bookmark name (head branch)
* title
  * flags: -t, --title
  * type: string
  * desc: Pull request title
* body
  * flags: --body
  * type: string
  * desc: Pull request body (optional)

~~~bash
if [ -n "$body" ]; then
  gh pr create --head "$bookmark" --base main --title "$title" --body "$body"
else
  gh pr create --head "$bookmark" --base main --title "$title"
fi
echo "✅ Pull request created"
~~~

## status

> Show current jj status

Shows the current working copy status.

~~~bash
jj status
~~~

## log

> Show jj commit history

Shows the commit log.

~~~bash
jj log
~~~

## diff

> Show changes in working copy

Shows the diff of current changes.

~~~bash
jj diff
~~~
