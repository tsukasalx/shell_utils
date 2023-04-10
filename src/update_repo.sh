#!/bin/bash

# Define a method to update the repository
function update_repo {
  if ! command -v git >/dev/null 2>&1; then
    echo "git is not installed."
    return 1
  fi

  # Change directory to project root
  pushd $1 >/dev/null
  # Get the current branch name
  current_branch=$(git rev-parse --abbrev-ref HEAD)

  # Check if the current branch is the specified branch
  if [ "$current_branch" != "$2" ]; then
      echo "Not in $2 branch, skip updating."
      popd >/dev/null
      return 1
  fi

  # Stash local modifications
  need_stash=false
  if ! git diff --quiet; then
    git stash
    need_stash=true
  fi

  # Pull the latest code
  git pull
  git submodule update

  # Pop local modifications
  if $need_stash; then
    git stash pop
  fi

  echo "Update completed."
  popd >/dev/null
  return 0
}
