#!/bin/bash
set -e

if [ ! -d .git ]; then
    echo "Not a git directory!"
    exit 1
fi

if [ -z "$(git show 2>/dev/null)" ]; then
    echo "No commits yet!"
    exit 1
fi

if [ -z "$INPUT_NAME" ] || [ -z "$INPUT_EMAIL" ]; then
    echo "Missing input \`name\` and/or \`email\`! Need them to commit."
    exit 1
fi

if [ -z "$INPUT_MESSAGE" ]; then
    echo "Missing input \`message\`! Need it as the commit message."
    exit 1
fi

if [ -z "$INPUT_DAYS" ]; then
    echo "Missing input \`days\`! Need it to calculate the number of days between the latest commit and the new commit."
    exit 1
fi

if [ -z "$INPUT_PUSH" ]; then
    echo "Missing input \`push\`! Need it to decide whether to push a new commit or not."
    exit 1
fi

# Subtract the current UNIX timestamp from the latest committed UNIX timestamp
# and divide by 86400 to get the number of interval days.
DAYS=$(( ($(date +%s)  - $(date +%s -d "$(git show -s --date=format:'%Y%m%d' --format=%cd)")) / 86400 ))

# If the number of days between is greater than or equal to the number
# of input days, create a new commit. Otherwise nothing to do.
if [ "$DAYS" -gt "$INPUT_DAYS" ] || [ "$DAYS" -eq "$INPUT_DAYS" ]; then
    echo "Create a new commit..."
    git config user.name "$INPUT_NAME"
    git config user.email "$INPUT_EMAIL"
    git commit --allow-empty --message "$INPUT_MESSAGE"

    if [ "$INPUT_PUSH" = "true" ]; then
        git push
    fi
else
    echo "Nothing to do..."
fi
