#!/usr/bin/env python3
"""
Telegram Unlimited Cloud Backup
Uploads OpenClaw backups to Telegram Saved Messages (unlimited storage!)
"""

import os
import sys
import asyncio
from datetime import datetime

# Check if telethon is installed
try:
    from telethon import TelegramClient
    from telethon.tl.types import InputPeerSelf
except ImportError:
    print("❌ Telethon not installed!")
    print("Install with: pip3 install telethon")
    sys.exit(1)

# Configuration
API_ID = os.environ.get('TELEGRAM_API_ID', '')
API_HASH = os.environ.get('TELEGRAM_API_HASH', '')
PHONE = os.environ.get('TELEGRAM_PHONE', '')
SESSION_NAME = 'openclaw_backup'

WORKSPACE = '/mnt/data/openclaw/workspace/.openclaw/workspace'
BACKUP_DIR = os.path.join(WORKSPACE, 'backups/enhanced/daily')

async def main():
    print("🚀 Telegram Unlimited Backup")
    print("===========================")
    
    # Check credentials
    if not all([API_ID, API_HASH, PHONE]):
        print("❌ Missing Telegram credentials!")
        print("\nSetup instructions:")
        print("1. Go to https://my.telegram.org/apps")
        print("2. Login with your phone number")
        print("3. Create new application")
        print("4. Copy api_id and api_hash")
        print("\nSet environment variables:")
        print("export TELEGRAM_API_ID='your_api_id'")
        print("export TELEGRAM_API_HASH='your_api_hash'")
        print("export TELEGRAM_PHONE='+62xxxxxxxxx'")
        sys.exit(1)
    
    # Create client
    client = TelegramClient(SESSION_NAME, int(API_ID), API_HASH)
    
    await client.start(phone=PHONE)
    print("✅ Logged in to Telegram")
    
    # Get latest backup
    latest_backup = None
    if os.path.exists(BACKUP_DIR):
        backups = sorted([f for f in os.listdir(BACKUP_DIR) if f.endswith('.tar.gz')])
        if backups:
            latest_backup = os.path.join(BACKUP_DIR, backups[-1])
    
    if not latest_backup or not os.path.exists(latest_backup):
        print("❌ No backup found to upload!")
        print(f"Looking in: {BACKUP_DIR}")
        await client.disconnect()
        sys.exit(1)
    
    print(f"📦 Found backup: {os.path.basename(latest_backup)}")
    
    # Get file size
    file_size = os.path.getsize(latest_backup) / (1024 * 1024)  # MB
    print(f"📊 File size: {file_size:.2f} MB")
    
    # Check if file is under Telegram limit (2GB for free, 4GB for premium)
    if file_size > 2000:
        print("⚠️  File exceeds 2GB Telegram limit!")
        print("Consider splitting backup or using compression")
    
    # Upload to Saved Messages
    print("📤 Uploading to Telegram Saved Messages...")
    print("(This may take a few minutes)")
    
    try:
        # Send to Saved Messages (user's own chat)
        await client.send_file(
            'me',  # 'me' refers to Saved Messages
            latest_backup,
            caption=f'🤖 OpenClaw Backup\n📅 {datetime.now().strftime("%Y-%m-%d %H:%M")}\n💾 {file_size:.2f} MB',
            progress_callback=lambda current, total: print(
                f"Progress: {current/(1024*1024):.2f}/{total/(1024*1024):.2f} MB ({current*100/total:.1f}%)",
                end='\r'
            )
        )
        print("\n✅ Upload complete!")
    except Exception as e:
        print(f"\n❌ Upload failed: {e}")
        await client.disconnect()
        sys.exit(1)
    
    await client.disconnect()
    print("\n🎉 Telegram backup complete!")
    print("Your backup is now stored in Telegram Saved Messages (unlimited storage!)")

if __name__ == '__main__':
    asyncio.run(main())
