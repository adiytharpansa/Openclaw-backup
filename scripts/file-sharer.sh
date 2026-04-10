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
