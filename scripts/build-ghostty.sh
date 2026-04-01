#!/bin/bash
set -euo pipefail

FORK_REPO="muxy-app/ghostty"

echo "==> Triggering GhosttyKit build on $FORK_REPO"
gh workflow run "Build GhosttyKit" --repo "$FORK_REPO"

echo "==> Build triggered. Check progress at:"
echo "    https://github.com/$FORK_REPO/actions"
echo ""
echo "    Once complete, the release will be available for the Muxy release workflow."
