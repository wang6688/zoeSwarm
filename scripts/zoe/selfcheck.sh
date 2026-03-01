#!/usr/bin/env bash
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel)"

ok() { echo "[OK]  $1"; }
fail() { echo "[FAIL] $1"; exit 1; }

command -v git >/dev/null 2>&1 && ok "git installed" || fail "git missing"
command -v tmux >/dev/null 2>&1 && ok "tmux installed" || fail "tmux missing"
command -v crontab >/dev/null 2>&1 && ok "crontab installed" || fail "crontab missing"
command -v codex >/dev/null 2>&1 && ok "codex installed" || fail "codex missing"

[[ -f "$ROOT/scripts/zoe/start_swarm.sh" ]] && ok "start_swarm.sh exists" || fail "start_swarm.sh missing"
[[ -f "$ROOT/scripts/zoe/spawn_agent.sh" ]] && ok "spawn_agent.sh exists" || fail "spawn_agent.sh missing"
[[ -f "$ROOT/scripts/zoe/monitor.sh" ]] && ok "monitor.sh exists" || fail "monitor.sh missing"
[[ -f "$ROOT/cron/zoe_monitor.cron" ]] && ok "cron template exists" || fail "cron template missing"

echo "ZOE_SELFCHECK_DONE"
