#!/usr/bin/env python3
"""Download music"""

import sys
sys.path.insert(0, '/mnt/data/openclaw/workspace/.openclaw/workspace')

from music_downloader.downloader import MusicDownloader

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: download <url> [quality]")
        sys.exit(1)
    
    downloader = MusicDownloader()
    url = sys.argv[1]
    quality = int(sys.argv[2]) if len(sys.argv) > 2 else 320
    
    downloader.download(url, quality)
