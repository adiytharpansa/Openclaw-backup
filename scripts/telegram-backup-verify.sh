#!/bin/bash
# Telegram Backup with Verification Code
cd /mnt/data/openclaw/workspace/.openclaw/workspace
export TELEGRAM_API_ID=31270730
export TELEGRAM_API_HASH=0cd7fb81b3ff39e48354aa265e4ad1a1
export TELEGRAM_PHONE=+6285745115673
export TELEGRAM_CODE=25342

# Create modified script that uses the code
cat > /tmp/telegram-backup-auto.py << 'PYEOF'
import os
import sys
import asyncio

try:
    from telethon import TelegramClient
except ImportError:
    print("❌ Telethon not installed!")
    sys.exit(1)

API_ID = os.environ.get('TELEGRAM_API_ID', '')
API_HASH = os.environ.get('TELEGRAM_API_HASH', '')
PHONE = os.environ.get('TELEGRAM_PHONE', '')
CODE = os.environ.get('TELEGRAM_CODE', '')
SESSION_NAME = 'openclaw_backup'

WORKSPACE = '/mnt/data/openclaw/workspace/.openclaw/workspace'
BACKUP_DIR = os.path.join(WORKSPACE, 'backups/enhanced/daily')

async def main():
    print("🚀 Telegram Unlimited Backup")
    print("===========================\n")
    
    client = TelegramClient(SESSION_NAME, int(API_ID), API_HASH)
    
    await client.start(phone=PHONE, password=None, code_callback=lambda: CODE)
    print("✅ Logged in to Telegram successfully!\n")
    
    # Find latest backup
    latest_backup = None
    if os.path.exists(BACKUP_DIR):
        backups = sorted([f for f in os.listdir(BACKUP_DIR) if f.endswith('.tar.gz')])
        if backups:
            latest_backup = os.path.join(BACKUP_DIR, backups[-1])
    
    if not latest_backup or not os.path.exists(latest_backup):
        print("❌ No backup found!")
        await client.disconnect()
        sys.exit(1)
    
    print(f"📦 Found backup: {os.path.basename(latest_backup)}")
    file_size = os.path.getsize(latest_backup) / (1024 * 1024)
    print(f"📊 File size: {file_size:.2f} MB\n")
    
    print("📤 Uploading to Telegram Saved Messages...")
    print("(This may take a few minutes)\n")
    
    try:
        await client.send_file(
            'me',
            latest_backup,
            caption=f'🤖 OpenClaw Backup\n📅 {__import__("datetime").datetime.now().strftime("%Y-%m-%d %H:%M")}\n💾 {file_size:.2f} MB',
            progress_callback=lambda c, t: print(f"Progress: {c*100/t:.1f}%", end='\r')
        )
        print("\n✅ Upload complete!")
    except Exception as e:
        print(f"\n❌ Upload failed: {e}")
        await client.disconnect()
        sys.exit(1)
    
    await client.disconnect()
    print("\n🎉 Telegram backup complete!")
    print("Your backup is stored in Telegram Saved Messages (UNLIMITED storage!)")

if __name__ == '__main__':
    asyncio.run(main())
PYEOF

python3 /tmp/telegram-backup-auto.py
