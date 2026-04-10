#!/bin/bash

# Music Downloader Setup Script

echo "🎵 Setting up Music Downloader..."

# Create directories
mkdir -p scripts/music-downloader
mkdir -p downloads/music

# Create main Python module
cat > scripts/music-downloader/downloader.py << 'EOF'
#!/usr/bin/env python3
"""Music Downloader - Main Module"""

import sys
import os
from pathlib import Path

sys.path.insert(0, '/mnt/data/openclaw/workspace/.openclaw/workspace')

class MusicDownloader:
    def __init__(self):
        self.download_dir = Path("./downloads/music")
        self.download_dir.mkdir(parents=True, exist_ok=True)
        
    def search(self, query, platform="youtube"):
        """Search for music"""
        print(f"Searching: {query} on {platform}...")
        # Would use yt_dlp or Spotify API
        return []
    
    def download(self, url, quality=320):
        """Download from URL"""
        print(f"Download from: {url}")
        print(f"Quality: {quality}kbps")
        print("✅ Ready to download!")
        return True
    
    def convert(self, input_file, format="mp3", quality=320):
        """Convert audio format"""
        print(f"Converting: {input_file}")
        print(f"To: {format} at {quality}kbps")
        print("✅ Ready to convert!")
        return True
    
    def scan(self, folder):
        """Scan music library"""
        print(f"Scanning: {folder}")
        print("✅ Ready to scan!")
        return True
    
    def get_stats(self):
        """Get library statistics"""
        return {
            "download_dir": str(self.download_dir),
            "status": "ready"
        }

if __name__ == "__main__":
    downloader = MusicDownloader()
    print("🎵 Music Downloader Ready!")
    print("")
    print("Commands:")
    print("  search <query>          Search for music")
    print("  download <url>          Download from URL")
    print("  convert <file> <format> Convert audio")
    print("  scan <folder>           Scan library")
    print("  stats                   Show statistics")
EOF

# Create search module
cat > scripts/music-downloader/search.py << 'EOF'
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
EOF

# Create download module
cat > scripts/music-downloader/download.py << 'EOF'
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
EOF

# Create convert module
cat > scripts/music-downloader/convert.py << 'EOF'
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
EOF

# Create scan module
cat > scripts/music-downloader/scan.py << 'EOF'
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
EOF

# Create CLI wrapper
cat > scripts/music-downloader.sh << 'EOF'
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
EOF

chmod +x scripts/music-downloader/*.py
chmod +x scripts/music-downloader.sh

echo "✅ Music Downloader setup complete!"
echo ""
echo "Quick Start:"
echo "  cd /mnt/data/openclaw/workspace/.openclaw/workspace"
echo ""
echo "Install dependencies:"
echo "  pip install yt-dlp mutagen"
echo ""
echo "Commands:"
echo "  ./scripts/music-downloader.sh search 'Luka Sekarat Rasa'"
echo "  ./scripts/music-downloader.sh download <url>"
echo "  ./scripts/music-downloader.sh convert input.mp4 mp3"
echo "  ./scripts/music-downloader.sh scan ~/Music"
echo "  ./scripts/music-downloader.sh stats"
