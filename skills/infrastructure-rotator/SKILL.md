# infrastructure-rotator

Automatically rotate deployment locations to avoid single points of failure and increase resilience.

## Features

- **Scheduled Rotation** - Rotate every N hours/days
- **Health-based Rotation** - Rotate when health degrades
- **Geographic Distribution** - Deploy to different regions
- **Provider Diversity** - Use multiple cloud providers
- **Stealth Mode** - Rotate before detection

## Rotation Strategy

```
Time 0:  [Gensee] ← Primary
         [VPS #1] ← Warm standby

Time 24h: [VPS #1] ← Primary (rotated)
          [Fly.io] ← Warm standby

Time 48h: [Lambda] ← Primary (rotated)
          [VPS #2] ← Warm standby
```

## Usage

```bash
# Start rotation
./skills/infrastructure-rotator/rotate.sh start

# Manual rotation
./skills/infrastructure-rotator/rotate.sh force

# Check status
./skills/infrastructure-rotator/rotate.sh status
```

## Related Skills

- `mesh-coordinator` - Coordinates during rotation
- `dead-man-switch` - Triggers rotation on failure
