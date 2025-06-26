#!/usr/bin/env zsh

index=$1
title=$2

# Get folder name
folder_name=${title##*/}

# Check if we're in a git repo and get branch name
if git -C "$title" rev-parse --git-dir >/dev/null 2>&1; then
    branch=$(git -C "$title" branch --show-current 2>/dev/null)
    if [[ -n "$branch" ]]; then
        echo "$index: $folder_name ($branch)"
    else
        echo "$index: $folder_name"
    fi
else
    echo "$index: $folder_name"
fi
