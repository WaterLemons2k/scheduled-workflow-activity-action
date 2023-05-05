#!/bin/bash
set -e

err() {
    echo "::error::$1" >&2
    return 1
}

if [ ! -d .git ]; then
    err "Not a git directory! Did you forget to run actions/checkout before running this action?"
fi

if [ -z "$(git show 2>/dev/null)" ]; then
    err "No commits yet!"
fi

if [ -z "$INPUT_NAME" ] || [ -z "$INPUT_EMAIL" ]; then
    err "Missing input \`name\` and/or \`email\`! Need them to commit."
fi

if [ -z "$INPUT_MESSAGE" ]; then
    err "Missing input \`message\`! Need it as the commit message."
fi

if [ -z "$INPUT_DAYS" ]; then
    err "Missing input \`days\`! Need it to calculate the number of days between the latest commit and the new commit."
fi

if [ -z "$INPUT_PUSH" ]; then
    err "Missing input \`push\`! Need it to decide whether to push a new commit or not."
fi

# Subtract the current UNIX timestamp from the latest committed UNIX timestamp
# and divide by 86400 to get the number of interval days.
DAYS=$(( ($(date +%s)  - $(date +%s -d "$(git show -s --date=format:'%Y%m%d' --format=%cd)")) / 86400 ))

# If the number of days between is greater than or equal to the
# number of input days, create a new commit. Otherwise nothing to do.
if [ "$DAYS" -ge "$INPUT_DAYS" ]; then
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
