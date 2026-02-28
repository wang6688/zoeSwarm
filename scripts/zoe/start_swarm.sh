#!/usr/bin/env bash
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel)"
mkdir -p "$ROOT/zoe"/{logs,state}
SESSION="zoe-control"
if ! tmux has-session -t "$SESSION" 2>/dev/null; then
  tmux new-session -d -s "$SESSION" -n coordinator "cd '$ROOT'; echo 'Zoe control ready at '$(date); bash"
fi
cat <<MSG
[Zoe] control session ready: $SESSION
Attach: tmux attach -t $SESSION
MSG
