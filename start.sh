#!/bin/bash

# Read environment variables
REPO=$REPO
ACCESS_TOKEN=$TOKEN

# Fetch the runner registration token given repo and gh access token
REG_TOKEN=$(curl -X POST -H "Authorization: token ${ACCESS_TOKEN}" -H "Accept: application/vnd.github+json" "https://api.github.com/repos/${REPO}/actions/runners/registration-token" | jq .token --raw-output)

cd /home/docker/actions-runner || exit 1

# Launch config script (obtained from runner code)
echo "Launching config.sh"
ls .
./config.sh --url "https://github.com/${REPO}" --token "${REG_TOKEN}"

# Set up automatic cleanup whenever runner is interrupted
cleanup() {
  echo "Removing runner..."
  ./config.sh remove --unattended --token "${REG_TOKEN}"
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!
