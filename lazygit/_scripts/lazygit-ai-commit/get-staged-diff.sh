#!/bin/bash
# Script to retrieve staged git diff with error handling and size limitation
# Requirements: 5.1, 2.4, 8.1

set -e
set -o pipefail

# Check if we are inside a git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Error: Not inside a git repository" >&2
    exit 1
fi

# Check if there are any staged changes
if git diff --cached --quiet; then
    echo "Error: No staged changes detected" >&2
    echo "Suggestion: Use 'space' to stage files, then retry" >&2
    exit 1
fi

# Get the staged diff and limit to 12KB (12000 bytes)
# This prevents exceeding AI token limits
git diff --cached | head -c 12000

exit 0
