#!/bin/sh

set -e

REPO=$1
BRANCH_NAME=$2
WORKFLOW_FILE_NAME=$3
TOKEN=$4

# Check the status of the branch

ID=$(curl -s -X GET -H "Accept: application/vnd.github.v3+json" -H "Authorization: token $TOKEN" "https://api.github.com/repos/$REPO/actions/workflows/$WORKFLOW_FILE_NAME/runs?branch=$BRANCH_NAME&status=in_progress" | jq -r '.workflow_runs[].id')

curl -X POST -H "Accept: application/vnd.github.v3+json" -H "Authorization: token $TOKEN" https://api.github.com/repos/$REPO/actions/runs/$ID/cancel

echo "Cancelling this build for $BRANCH_NAME because of job failures..."  
