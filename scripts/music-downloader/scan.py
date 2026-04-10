#!/usr/bin/env python3
"""Scan music library"""

import sys
sys.path.insert(0, '/mnt/data/openclaw/workspace/.openclaw/workspace')

from music_downloader.downloader import MusicDownloader

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: scan <folder>")
        sys.exit(1)
    
    downloader = MusicDownloader()
    folder = sys.argv[1]
    
    downloader.scan(folder)
