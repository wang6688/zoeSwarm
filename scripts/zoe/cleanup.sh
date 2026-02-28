#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <branch-name>"
  exit 1
fi
BRANCH="$1"
ROOT="$(git rev-parse --show-toplevel)"
SESSION="zoe-${BRANCH//\//-}"
WORKTREE="${ROOT}/.worktrees/${BRANCH}"

if tmux has-session -t "$SESSION" 2>/dev/null; then
  tmux kill-session -t "$SESSION"
  echo "Killed session: $SESSION"
fi
if [[ -d "$WORKTREE" ]]; then
  git worktree remove "$WORKTREE" --force
  echo "Removed worktree: $WORKTREE"
fi
