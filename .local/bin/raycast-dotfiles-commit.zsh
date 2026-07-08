#!/usr/bin/env zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Dotfiles Commit
# @raycast.description Show dotfiles changes in kitty, select files, commit with nvim, and push
# @raycast.icon 
# @raycast.mode silent

export KITTY_LISTEN_ON="unix:/tmp/mykitty"

DOTFILES_DIR="$HOME"
GIT_DIR="$HOME/Code/personal/dotfiles"

# Get list of changed files
CHANGED=$(git --git-dir="$GIT_DIR" --work-tree="$DOTFILES_DIR" status --short 2>/dev/null)

if [[ -z "$CHANGED" ]]; then
  echo "No changes to dotfiles"
  exit 0
fi

# Create a temp file with the list of changed files for selection
TEMP_FILE=$(mktemp /tmp/dotfiles-commit.XXXXXX)
echo "$CHANGED" | awk '{print $2}' > "$TEMP_FILE"

# Launch kitty with a shell script that:
# 1. Shows the diff
# 2. Lets user select files
# 3. Commits with nvim
# 4. Pushes
kitty @ launch --type=tab --title="Dotfiles Commit" --cwd="$HOME" zsh -c "
  export PATH=\"$HOME/.local/share/mise/shims:$HOME/.local/bin:$HOME/nvim/bin:/opt/homebrew/bin:\$PATH\"
  
  echo '=== Dotfiles Changes ==='
  git --git-dir='$GIT_DIR' --work-tree='$HOME' status --short
  echo ''
  echo '=== Full Diff ==='
  git --git-dir='$GIT_DIR' --work-tree='$HOME' diff --color=always 2>/dev/null | less -R
  echo ''
  
  # Select files to stage
  FILES=\$(git --git-dir='$GIT_DIR' --work-tree='$HOME' status --short | awk '{print \$2}' | fzf --multi --prompt='Select files to stage > ' --height=40%)
  
  if [[ -z \"\$FILES\" ]]; then
    echo 'No files selected. Aborting.'
    exit 0
  fi
  
  echo ''
  echo 'Staging selected files...'
  echo \"\$FILES\" | while read -r f; do
    git --git-dir='$GIT_DIR' --work-tree='$HOME' add \"\$f\"
  done
  
  echo ''
  echo 'Staged files:'
  git --git-dir='$GIT_DIR' --work-tree='$HOME' diff --cached --name-only
  echo ''
  
  # Commit with neovim
  echo 'Opening neovim for commit message...'
  git --git-dir='$GIT_DIR' --work-tree='$HOME' commit --quiet 2>/dev/null
  
  if [[ \$? -ne 0 ]]; then
    echo 'Commit failed or was cancelled.'
    exit 1
  fi
  
  echo ''
  echo 'Pushing...'
  git --git-dir='$GIT_DIR' --work-tree='$HOME' push 2>&1
  
  echo ''
  echo 'Done! Press any key to close.'
  read -k 1
" 2>/dev/null
