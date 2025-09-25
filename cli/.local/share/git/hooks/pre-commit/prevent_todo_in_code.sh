#!/bin/bash

# Pre-commit hook to prevent commits with TODO: comments
# Save this file as .git/hooks/pre-commit and make it executable

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get list of files being committed (staged files)
files=$(git diff --cached --name-only --diff-filter=ACM)

# Flag to track if TODOs were found
todo_found=false

echo "Checking for TODO comments in staged files..."

# Check each staged file for TODO: comments
for file in $files; do
  # Skip binary files and files that don't exist (deleted files)
  if [[ -f "$file" ]] && file -b --mime-type "$file" | grep -q "^text/"; then
    # Search for TODO: (case insensitive) in the file
    todo_lines=$(grep -n -i "TODO:" "$file" 2>/dev/null)

    if [[ $? -eq 0 ]]; then
      if [[ "$todo_found" == false ]]; then
        echo -e "${RED}ERROR: Found TODO comments in staged files:${NC}"
        todo_found=true
      fi

      echo -e "${YELLOW}$file:${NC}"
      # Display the lines with TODO comments
      echo "$todo_lines" | while read -r line; do
        echo "  $line"
      done
      echo
    fi
  fi
done

# If TODOs were found, reject the commit
if [[ "$todo_found" == true ]]; then
  echo -e "${RED}Commit rejected!${NC}"
  echo "Please resolve all TODO comments before committing."
  echo "If you need to commit with TODOs, you can:"
  echo "  1. Remove or resolve the TODO comments"
  echo "  2. Use 'git commit --no-verify' to bypass this hook (not recommended)"
  exit 1
fi

echo "No TODO comments found. Proceeding with commit."
exit 0
