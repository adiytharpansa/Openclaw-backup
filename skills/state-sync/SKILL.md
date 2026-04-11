# state-sync

Encrypted synchronization of OpenClaw state (memory, config, logs) to external storage. Enables recovery and failover across instances.

## Supported Backends

- **GitHub** - Encrypted memory/config in private repo
- **S3/MinIO** - Object storage for full state backups
- **Google Drive** - Personal cloud storage
- **IPFS** - Decentralized storage
- **Encrypted Email** - State as encrypted attachment

## Features

- **End-to-end encryption** - AES-256 encryption before upload
- **Incremental sync** - Only sync changed files
- **Version history** - Keep last N versions
- **Auto-restore** - Recover state on new instance
- **Conflict resolution** - Merge or prefer latest

## Usage

```bash
# Sync state
./skills/state-sync/sync.sh push

# Recover state
./skills/state-sync/sync.sh pull

# Check status
./skills/state-sync/sync.sh status
```

## Related Skills

- `dead-man-switch` - Triggers state sync on failover
- `mesh-coordinator` - Syncs across mesh network
