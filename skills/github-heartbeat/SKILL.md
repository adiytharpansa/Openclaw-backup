# github-heartbeat

Dead Man's Switch menggunakan GitHub Actions (tanpa Cloudflare Worker!).

## How It Works

```
OpenClaw Instance
       ↓ heartbeat (every 5 min)
GitHub Repo (.heartbeat file)
       ↓ check (every 5 min)
GitHub Actions Monitor
       ↓ no heartbeat 30 min
Emergency Deploy Triggered
```

## Usage

```bash
# Send heartbeat manually
skills/github-heartbeat/send-heartbeat.sh send

# Enable auto-heartbeat
skills/github-heartbeat/send-heartbeat.sh enable

# Check status
skills/github-heartbeat/send-heartbeat.sh status
```

## Related Workflows

- `.github/workflows/heartbeat-monitor.yml` - Monitor & emergency deploy
