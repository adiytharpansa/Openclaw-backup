# gitops-deploy

Git-triggered deployment. Push to GitHub → Auto-deploy to all configured infrastructure.

## How It Works

```
[You] → git push → [GitHub] → [GitHub Actions] → [Deploy to all targets]
                                              ↓
                              VPS + Lambda + Fly.io + More
```

## Features

- **Git-triggered** - Any push triggers deployment
- **Multi-target** - Deploy to all platforms simultaneously
- **Rollback** - Git revert = instant rollback
- **Audit Trail** - Full git history of deployments
- **Secrets Management** - Encrypted secrets via GitHub Secrets

## Usage

```bash
# Setup
./skills/gitops-deploy/setup.sh

# Manual trigger
./skills/gitops-deploy/deploy.sh

# Check status
./skills/gitops-deploy/status.sh
```

## Related Skills

- `dead-man-switch` - Can trigger gitops on failure
- `state-sync` - Syncs state to git repo
