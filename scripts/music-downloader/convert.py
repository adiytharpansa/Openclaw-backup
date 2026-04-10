#!/usr/bin/env python3
"""Convert audio"""

import sys
sys.path.insert(0, '/mnt/data/openclaw/workspace/.openclaw/workspace')

from music_downloader.downloader import MusicDownloader

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: convert <input> <format>")
        sys.exit(1)
    
    downloader = MusicDownloader()
    input_file = sys.argv[1]
    format = sys.argv[2]
    
    downloader.convert(input_file, format)
