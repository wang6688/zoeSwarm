# Zoe Orchestration Layer (Codex-only)

This setup creates a minimal working AI agent swarm loop on your machine:
- Zoe = coordinator (you + OpenClaw workflow)
- Codex agents = coding workers (tmux-based)
- Cron monitor = periodic health checks every 10 minutes

## Structure
- `scripts/zoe/start_swarm.sh`      Start tmux control session and bootstrap files
- `scripts/zoe/spawn_agent.sh`      Spawn 1 Codex coding agent in isolated worktree+tmux
- `scripts/zoe/monitor.sh`          Check tmux/worktree/git/CI status, log snapshot
- `scripts/zoe/create_pr.sh`        Create PR via gh (if installed), otherwise print next steps
- `scripts/zoe/cleanup.sh`          Remove completed worktree + tmux session
- `zoe/prompts/codex_task.prompt.md` Prompt template for Codex workers
- `cron/zoe_monitor.cron`           Cron template (every 10 minutes)

## Prerequisites
- Required: `git`, `tmux`, `crontab`, `codex`
- Optional but recommended: `gh`

## Quick Start
```bash
bash scripts/zoe/start_swarm.sh
bash scripts/zoe/spawn_agent.sh feature/login-fix "实现登录错误处理并补测试"
bash scripts/zoe/monitor.sh
```

## Install monitor cron
```bash
(crontab -l 2>/dev/null; cat cron/zoe_monitor.cron) | crontab -
```

## Quick environment self-check
```bash
bash scripts/zoe/selfcheck.sh
```


## Notes
- Codex model is pinned to `gpt-5.3-codex`
- Reasoning effort is set to `high`
- All coding tasks are Codex-only by design
