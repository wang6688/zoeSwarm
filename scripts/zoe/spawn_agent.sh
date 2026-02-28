#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <branch-name> <task-text>"
  exit 1
fi
BRANCH="$1"; shift
TASK="$*"
ROOT="$(git rev-parse --show-toplevel)"
REPO_NAME="$(basename "$ROOT")"
WORKBASE="${ROOT}/.worktrees"
WORKTREE="${WORKBASE}/${BRANCH}"
SESSION="zoe-${BRANCH//\//-}"
MODEL="gpt-5.3-codex"

mkdir -p "$WORKBASE" "$ROOT/zoe/logs" "$ROOT/zoe/state"
if [[ ! -d "$WORKTREE" ]]; then
  git worktree add -b "$BRANCH" "$WORKTREE"
fi

PROMPT_FILE="$ROOT/zoe/state/${SESSION}.prompt.md"
sed -e "s|{{TASK}}|${TASK}|g" \
    -e "s|{{BRANCH}}|${BRANCH}|g" \
    -e "s|{{REPO}}|${REPO_NAME}|g" \
    "$ROOT/zoe/prompts/codex_task.prompt.md" > "$PROMPT_FILE"

CMD="cd '$WORKTREE' && codex --model ${MODEL} --reasoning-effort high exec \"$(cat "$PROMPT_FILE" | tr '\n' ' ' | sed 's/"/\\"/g')\" | tee -a '$ROOT/zoe/logs/${SESSION}.log'"

if tmux has-session -t "$SESSION" 2>/dev/null; then
  echo "Session already exists: $SESSION"
  exit 1
fi

tmux new-session -d -s "$SESSION" -n worker "$CMD"

echo "$SESSION|$BRANCH|$WORKTREE|$(date +%s)" >> "$ROOT/zoe/state/agents.tsv"
cat <<MSG
[Zoe] spawned Codex worker
session : $SESSION
branch  : $BRANCH
worktree: $WORKTREE
log     : $ROOT/zoe/logs/${SESSION}.log
MSG
