#!/usr/bin/env bash
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel)"
STATE="$ROOT/zoe/state/agents.tsv"
OUT="$ROOT/zoe/logs/monitor-$(date +%F).log"
mkdir -p "$ROOT/zoe/logs"

echo "=== $(date '+%F %T') Zoe monitor ===" | tee -a "$OUT"
if [[ ! -f "$STATE" ]]; then
  echo "No agents registered" | tee -a "$OUT"
  exit 0
fi

while IFS='|' read -r SESSION BRANCH WORKTREE STARTTS; do
  [[ -z "${SESSION:-}" ]] && continue
  if tmux has-session -t "$SESSION" 2>/dev/null; then
    STATUS="UP"
  else
    STATUS="DOWN"
  fi
  HEAD="-"
  if [[ -d "$WORKTREE/.git" || -f "$WORKTREE/.git" ]]; then
    HEAD="$(git -C "$WORKTREE" rev-parse --short HEAD 2>/dev/null || echo '-')"
  fi
  DIRTY="-"
  if [[ -d "$WORKTREE" ]]; then
    DIRTY="$(git -C "$WORKTREE" status --porcelain 2>/dev/null | wc -l | tr -d ' ')"
  fi
  echo "$SESSION | $STATUS | $BRANCH | head:$HEAD | dirty:$DIRTY" | tee -a "$OUT"
done < "$STATE"
