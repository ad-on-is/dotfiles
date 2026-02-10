#!/bin/sh

if git diff --cached --quiet; then
  if git rev-parse --verify HEAD >/dev/null 2>&1; then
    if [ -f .git/COMMIT_EDITMSG ]; then
      exit 0
    fi
  fi

  echo "Error: No files staged for commit."
  echo "Please use 'git add -p' to stage changes interactively."
  exit 1
fi
