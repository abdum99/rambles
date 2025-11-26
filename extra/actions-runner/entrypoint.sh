#!/usr/bin/env bash
set -euo pipefail

cd /actions-runner

: "${GH_RUNNER_URL:?GH_RUNNER_URL is required (e.g. https://github.com/owner/repo or https://github.com/orgs/ORG_NAME)}"
: "${GH_RUNNER_TOKEN:?GH_RUNNER_TOKEN is required (GitHub self-hosted runner registration token)}"

RUNNER_NAME="${GH_RUNNER_NAME:-$(hostname)}"
RUNNER_LABELS="${GH_RUNNER_LABELS:-self-hosted,hugo}"
RUNNER_WORKDIR="${RUNNER_WORKDIR:-_work}"

echo "Configuring GitHub Actions runner..."
if [ ! -f .runner ]; then
  ./config.sh \
    --unattended \
    --replace \
    --url "${GH_RUNNER_URL}" \
    --token "${GH_RUNNER_TOKEN}" \
    --name "${RUNNER_NAME}" \
    --work "${RUNNER_WORKDIR}" \
    --labels "${RUNNER_LABELS}"
fi

cleanup() {
  echo "Removing runner..."
  ./config.sh remove --unattended --token "${GH_RUNNER_TOKEN}" || true
  exit 0
}

trap cleanup SIGINT SIGTERM

echo "Starting GitHub Actions runner..."
exec ./run.sh
