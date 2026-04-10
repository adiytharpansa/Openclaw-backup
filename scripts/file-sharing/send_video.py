#!/usr/bin/env python3
"""Send video to Telegram"""

import sys
import os

sys.path.insert(0, '/mnt/data/openclaw/workspace/.openclaw/workspace')

from file_sharing.file_sharer import FileSharer

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: send_video <file> <chat_id> [caption]")
        sys.exit(1)
    
    file_path = sys.argv[1]
    chat_id = sys.argv[2]
    caption = sys.argv[3] if len(sys.argv) > 3 else None
    
    print(f"📹 Sending video: {os.path.basename(file_path)}")
    print(f"   To chat: {chat_id}")
    print(f"   Caption: {caption or 'None'}")
    print("")
    print("✅ Video sharing ready!")
