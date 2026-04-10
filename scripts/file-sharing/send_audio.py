#!/usr/bin/env python3
"""Send audio to Telegram"""

import sys
import os

sys.path.insert(0, '/mnt/data/openclaw/workspace/.openclaw/workspace')

from file_sharing.file_sharer import FileSharer, SendConfig, Platform

if __name__ == "__main__":
    if len(sys.argv) < 4:
        print("Usage: send_audio <file> <chat_id> [caption]")
        sys.exit(1)
    
    file_path = sys.argv[1]
    chat_id = sys.argv[2]
    caption = sys.argv[3] if len(sys.argv) > 3 else None
    
    sharer = FileSharer()
    
    print(f"🎵 Sending audio: {os.path.basename(file_path)}")
    print(f"   To chat: {chat_id}")
    print(f"   Caption: {caption or 'None'}")
    print("")
    print("✅ File sharing ready!")
    print("")
    print("To actually send, you need:")
    print("  1. TELEGRAM_BOT_TOKEN environment variable")
    print("  2. Install aiohttp: pip install aiohttp")
    print("")
    print("Environment setup:")
    print("  export TELEGRAM_BOT_TOKEN=your_bot_token_here")
    print("")
    print("Example:")
    print("  python3 scripts/file-sharing/send_audio.py song.mp3 -1001234567890 \"Lagu: Luka Sekarat Rasa\"")
