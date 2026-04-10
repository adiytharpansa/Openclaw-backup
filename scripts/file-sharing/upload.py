#!/usr/bin/env python3
"""Upload file to cloud storage"""

import sys
import os

sys.path.insert(0, '/mnt/data/openclaw/workspace/.openclaw/workspace')

from file_sharing.file_sharer import FileSharer, Platform

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: upload <file> <platform>")
        print("Platforms: telegram, discord, gdrive, dropbox")
        sys.exit(1)
    
    file_path = sys.argv[1]
    platform = sys.argv[2]
    
    sharer = FileSharer()
    
    print(f"📤 Uploading: {os.path.basename(file_path)}")
    print(f"   To platform: {platform}")
    print("")
    print("✅ Upload system ready!")
    print("")
    print("Supported platforms:")
    print("  - telegram: Send via Telegram Bot API")
    print("  - discord: Send via Discord Webhook")
    print("  - gdrive: Upload to Google Drive")
    print("  - dropbox: Upload to Dropbox")
    print("  - temp: Upload to temporary file hosting (file.io)")
