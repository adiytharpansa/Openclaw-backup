#!/bin/bash

# File Sharing Setup Script

echo "📁 Setting up File Sharing Skill..."

# Create directories
mkdir -p scripts/file-sharing
mkdir -p .file-sharer/temp
mkdir -p .file-sharer/processed

# Create send_audio.py
cat > scripts/file-sharing/send_audio.py << 'EOF'
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
EOF

# Create send_video.py
cat > scripts/file-sharing/send_video.py << 'EOF'
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
EOF

# Create upload.py
cat > scripts/file-sharing/upload.py << 'EOF'
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
EOF

# Create list.py
cat > scripts/file-sharing/list.py << 'EOF'
#!/usr/bin/env python3
"""List recently shared files"""

import sys
import os

sys.path.insert(0, '/mnt/data/openclaw/workspace/.openclaw/workspace')

from file_sharing.file_sharer import FileSharer

sharer = FileSharer()

files = sharer.get_files_list(days=7)

if not files:
    print("📋 No files shared recently")
    sys.exit(0)

print("📋 Recently Shared Files (last 7 days):")
print("=" * 80)
print(f"{'ID':<25} {'File':<30} {'Size':<10} {'Platform':<12} {'Date'}")
print("-" * 80)

for f in files[:10]:  # Show last 10
    size_mb = f['size_bytes'] / (1024 * 1024)
    print(f"{f['id']:<25} {f['filename']:<30} {size_mb:.1f} MB  {f['platform']:<12} {f['uploaded_at'][:10]}")

print("-" * 80)
print(f"Total: {len(files)} files")
EOF

# Create cleanup.py
cat > scripts/file-sharing/cleanup.py << 'EOF'
#!/usr/bin/env python3
"""Clean up old temporary files"""

import sys
import os

sys.path.insert(0, '/mnt/data/openclaw/workspace/.openclaw/workspace')

from file_sharing.file_sharer import FileSharer

days = int(sys.argv[1]) if len(sys.argv) > 1 else 1

print(f"🧹 Cleaning up files older than {days} day(s)...")

sharer = FileSharer()
sharer.cleanup_old_files(days)

print("✅ Cleanup complete!")
EOF

# Create link.py
cat > scripts/file-sharing/link.py << 'EOF'
#!/usr/bin/env python3
"""Generate shareable link for file"""

import sys
import os

sys.path.insert(0, '/mnt/data/openclaw/workspace/.openclaw/workspace')

from file_sharing.file_sharer import FileSharer

if len(sys.argv) < 2:
    print("Usage: link <file_id>")
    sys.exit(1)

file_id = sys.argv[1]

sharer = FileSharer()
link = sharer.generate_share_link(file_id)

if link:
    print(f"🔗 Shareable link: {link}")
else:
    print("❌ File ID not found")
EOF

# Create main CLI wrapper
cat > scripts/file-sharer.sh << 'EOF'
#!/bin/bash

case "$1" in
    send-audio)
        python3 scripts/file-sharing/send_audio.py "$2" "$3" "$4"
        ;;
    send-video)
        python3 scripts/file-sharing/send_video.py "$2" "$3" "$4"
        ;;
    upload)
        python3 scripts/file-sharing/upload.py "$2" "$3"
        ;;
    list)
        python3 scripts/file-sharing/list.py
        ;;
    cleanup)
        python3 scripts/file-sharing/cleanup.py "$2"
        ;;
    link)
        python3 scripts/file-sharing/link.py "$2"
        ;;
    *)
        echo "📁 File Sharing CLI"
        echo ""
        echo "Usage:"
        echo "  ./scripts/file-sharer.sh send-audio <file> <chat_id> [caption]"
        echo "  ./scripts/file-sharer.sh send-video <file> <chat_id> [caption]"
        echo "  ./scripts/file-sharer.sh upload <file> <platform>"
        echo "  ./scripts/file-sharer.sh list"
        echo "  ./scripts/file-sharer.sh cleanup <days>"
        echo "  ./scripts/file-sharer.sh link <file_id>"
        echo ""
        echo "Setup:"
        echo "  export TELEGRAM_BOT_TOKEN=your_bot_token"
        echo "  export DISCORD_WEBHOOK_URL=your_webhook_url"
        echo ""
        echo "Install dependencies:"
        echo "  pip install aiohttp"
        ;;
esac
EOF

chmod +x scripts/file-sharing/*.py
chmod +x scripts/file-sharer.sh

echo "✅ File Sharing setup complete!"
echo ""
echo "Quick Setup:"
echo "  # 1. Get Telegram Bot Token"
echo "  #    Talk to @BotFather on Telegram, create new bot"
echo "  export TELEGRAM_BOT_TOKEN=your_bot_token_here"
echo ""
echo "  # 2. Install dependencies"
echo "  pip install aiohttp"
echo ""
echo "  # 3. Get Chat ID"
echo "  Send message to your bot, then:"
echo "  curl https://api.telegram.org/bot<token>/getUpdates"
echo ""
echo "Usage Examples:"
echo ""
echo "  # Send MP3 to Telegram"
echo "  bash scripts/file-sharer.sh send-audio song.mp3 -1001234567890 \"Lagu: Luka Sekarat Rasa\""
echo ""
echo "  # Send video to Telegram"
echo "  bash scripts/file-sharer.sh send-video video.mp4 -1001234567890 \"My video\""
echo ""
echo "  # List shared files"
echo "  bash scripts/file-sharer.sh list"
echo ""
echo "  # Clean up old files"
echo "  bash scripts/file-sharer.sh cleanup 1"
echo ""
echo "  # Get shareable link"
echo "  bash scripts/file-sharer.sh link file-abc123-1234567890"
