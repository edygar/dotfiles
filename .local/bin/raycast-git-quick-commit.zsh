#!/usr/bin/env zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Git Quick Commit
# @raycast.description Stage tracked changes, prompt for commit message, and push
# @raycast.icon 
# @raycast.mode compact

# Get the current git root
GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
if [[ -z "$GIT_ROOT" ]]; then
  echo "Not in a git repository"
  exit 1
fi

cd "$GIT_ROOT"

# Show git status
echo "=== Git Status ==="
git status --short
echo ""

# Stage only tracked (versioned) files that changed
CHANGED=$(git diff --name-only 2>/dev/null)
STAGED=$(git diff --cached --name-only 2>/dev/null)

if [[ -z "$CHANGED" ]] && [[ -z "$STAGED" ]]; then
  echo "No changes to commit"
  exit 0
fi

git add -u 2>/dev/null
echo "Staged tracked files."
echo ""

# Prompt for commit message
printf "Commit message: "
read -r COMMIT_MSG

if [[ -z "$COMMIT_MSG" ]]; then
  echo "No commit message provided, aborting."
  git reset HEAD 2>/dev/null
  exit 1
fi

# Commit and push
git commit -m "$COMMIT_MSG" 2>&1
echo ""
git push 2>&1
echo ""
echo "Done."
