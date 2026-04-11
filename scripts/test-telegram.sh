#!/bin/bash
# Test Telegram Backup
cd /mnt/data/openclaw/workspace/.openclaw/workspace
export TELEGRAM_API_ID=31270730
export TELEGRAM_API_HASH=0cd7fb81b3ff39e48354aa265e4ad1a1
export TELEGRAM_PHONE=+6285745115673
python3 scripts/telegram-backup.py
