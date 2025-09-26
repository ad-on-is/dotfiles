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

echo "Checking for TODO comments in your changes..."

# Check each staged file for TODO: comments in added/modified lines only
for file in $files; do
  # Skip binary files and files that don't exist (deleted files)
  if [[ -f "$file" ]] && file -b --mime-type "$file" | grep -q "^text/"; then
    # Get the diff for this file to see only added/modified lines
    # Use git diff --cached to get staged changes with line numbers
    added_lines=$(git diff --cached -U0 "$file" | grep "^+" | grep -v "^+++" | grep -i "TODO:")

    if [[ -n "$added_lines" ]]; then
      if [[ "$todo_found" == false ]]; then
        echo -e "${RED}ERROR: Found TODO comments in your changes:${NC}"
        todo_found=true
      fi

      echo -e "${YELLOW}$file:${NC}"
      # Display the added lines with TODO comments
      echo "$added_lines" | while read -r line; do
        # Remove the leading + from diff output for cleaner display
        clean_line=$(echo "$line" | sed 's/^+//')
        echo "  + $clean_line"
      done
      echo
    fi
  fi
done

# If TODOs were found, reject the commit
if [[ "$todo_found" == true ]]; then
  exit 1
fi

exit 0
