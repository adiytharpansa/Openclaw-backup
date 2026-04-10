#!/usr/bin/env python3
"""Search music"""

import sys
sys.path.insert(0, '/mnt/data/openclaw/workspace/.openclaw/workspace')

from music_downloader.downloader import MusicDownloader

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: search <query>")
        sys.exit(1)
    
    downloader = MusicDownloader()
    query = " ".join(sys.argv[1:])
    
    print(f"🔍 Searching: {query}")
    print("Search functionality requires additional dependencies:")
    print("  - yt_dlp (YouTube)")
    print("  - spotipy (Spotify)")
    print("")
    print("Install with:")
    print("  pip install yt-dlp spotipy")
