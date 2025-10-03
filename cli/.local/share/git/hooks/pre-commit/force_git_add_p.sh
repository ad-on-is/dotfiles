#!/bin/sh

# Check if commit was made with -a flag
if git diff --cached --quiet; then
  echo "Error: No files staged for commit."
  echo "Please use 'git add -p' to stage changes interactively."
  exit 1
fi
