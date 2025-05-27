#!/bin/bash

# Track and optionally pull all remote branches from origin
# Usage: ./track-all-remote-branches.sh [-f] [-p]
#   -f: Force re-track even if local branch exists
#   -p: Pull latest changes after tracking

force=false
pull=false

# Parse arguments
while getopts ":fp" opt; do
  case $opt in
    f) force=true ;;
    p) pull=true ;;
    *) echo "Usage: $0 [-f] [-p]"; exit 1 ;;
  esac
done

for remote_branch in $(git branch -r | grep -v '\->'); do
    local_branch="${remote_branch#origin/}"

    if git show-ref --verify --quiet "refs/heads/$local_branch"; then
        if [ "$force" = true ]; then
            echo "Force tracking: $local_branch -> $remote_branch"
            git branch -f "$local_branch" "$remote_branch"
        else
            echo "Skipping: local branch '$local_branch' already exists."
        fi
    else
        echo "Tracking new branch: $local_branch -> $remote_branch"
        git branch --track "$local_branch" "$remote_branch"
    fi

    if [ "$pull" = true ]; then
        echo "Pulling latest commits for $local_branch..."
        git checkout "$local_branch" >/dev/null 2>&1
        git pull origin "$local_branch"
    fi
done

# Go back to previous branch if changed
git checkout - >/dev/null 2>&1
