#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <worktree-path> <pr-title> [pr-body-file]"
  exit 1
fi
WT="$1"; TITLE="$2"; BODY_FILE="${3:-}"
if ! command -v gh >/dev/null 2>&1; then
  echo "gh is not installed. Install and auth first:"
  echo "  brew install gh"
  echo "  gh auth login"
  exit 2
fi
cd "$WT"
if [[ -n "$BODY_FILE" ]]; then
  gh pr create --fill --title "$TITLE" --body-file "$BODY_FILE"
else
  gh pr create --fill --title "$TITLE"
fi
