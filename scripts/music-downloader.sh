#!/bin/bash

case "$1" in
    search)
        python3 scripts/music-downloader/search.py "$2"
        ;;
    download)
        python3 scripts/music-downloader/download.py "$2" "$3"
        ;;
    convert)
        python3 scripts/music-downloader/convert.py "$2" "$3"
        ;;
    scan)
        python3 scripts/music-downloader/scan.py "$2"
        ;;
    stats)
        python3 scripts/music-downloader/downloader.py
        ;;
    *)
        echo "🎵 Music Downloader CLI"
        echo ""
        echo "Usage:"
        echo "  ./scripts/music-downloader.sh search <query>"
        echo "  ./scripts/music-downloader.sh download <url> [quality]"
        echo "  ./scripts/music-downloader.sh convert <file> <format>"
        echo "  ./scripts/music-downloader.sh scan <folder>"
        echo "  ./scripts/music-downloader.sh stats"
        ;;
esac
