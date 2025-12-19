#!/bin/bash
set -eo pipefail
. colors.sh

debug() {
	echo "::debug::$1"
}
warn() {
	echo "::warning::$1"
}
err() {
	echo "::error::$1" >&2
	exit 1
}

get_workflow_name() {
	local ref=$GITHUB_WORKFLOW_REF
	[ -z "$ref" ] && err 'No workflows'

	ref=${ref%@*}  # split('@')[0]
	ref=${ref##*/} # split('/')[-1]
	echo "$ref"
}

[ -z "$GITHUB_REPOSITORY" ] && err 'Missing repository'
export GH_TOKEN=$INPUT_TOKEN
[ -z "$GH_TOKEN" ] && err 'Missing token'
[ -z "$INPUT_WORKFLOWS" ] && INPUT_WORKFLOWS=$(get_workflow_name)

HAS_FAILED=false
API_BASE=repos/$GITHUB_REPOSITORY/actions/workflows
for workflow in $INPUT_WORKFLOWS; do
	endpoint=$API_BASE/$workflow/enable
	debug "endpoint: $endpoint"

	if gh api -X PUT "$endpoint"; then
		echo "$(green '✓ Enabled') $workflow"
	else
		warn "$(red '✗ Failed to enable') $workflow"
		HAS_FAILED=true
	fi
done

if [ "$HAS_FAILED" = true ]; then
	err 'One or more workflows failed to enable; check the logs for details. Note that you may need to grant the "actions" permission with write access, or directly grant read and write permissions for Actions in the repository settings. (see https://stackoverflow.com/a/75250838)'
fi
