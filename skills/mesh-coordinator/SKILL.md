# mesh-coordinator

Coordinate multiple OpenClaw instances in a mesh network. Enables distributed consensus, load balancing, and failover.

## Features

- **Instance Discovery** - Auto-discover other instances
- **Health Monitoring** - Monitor peer health
- **Consensus** - Vote on state changes
- **Load Balancing** - Distribute requests across instances
- **Failover** - Automatic leader election

## Network Topology

```
       ┌─────────────┐
       │  Leader     │
       │ (Gensee)    │
       └──────┬──────┘
              │
    ┌─────────┼─────────┐
    │         │         │
    ↓         ↓         ↓
┌──────┐ ┌──────┐ ┌──────┐
│Node 1│ │Node 2│ │Node 3│
│ (VPS)│ │(Lambda)│ │(Fly) │
└──────┘ └──────┘ └──────┘
```

## Usage

```bash
# Join mesh network
./skills/mesh-coordinator/join.sh

# Check network status
./skills/mesh-coordinator/status.sh

# Send message to all nodes
./skills/mesh-coordinator/broadcast.sh "message"
```

## Related Skills

- `dead-man-switch` - Triggers failover
- `state-sync` - Syncs state across mesh
