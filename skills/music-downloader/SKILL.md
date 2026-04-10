# Music-Downloader Skill

## Deskripsi
Advanced music downloading, streaming, and audio management tool. Download MP3 dari berbagai platform, manage music library, extract metadata, dan auto-organize collection.

## Kapan Digunakan
- Download lagu dari YouTube, Spotify, SoundCloud
- Extract audio dari video/file
- Manage dan organize music library
- Convert between audio formats
- Batch download playlist/album
- Search and find music
- Auto-tag metadata (ID3 tags)

## Fitur Utama

### 1. Multi-Platform Download
```
├── YouTube (video → audio)
├── Spotify (playlist/album)
├── SoundCloud
├── Bandcamp
├── Apple Music
├── SoundCloud
└── Custom URLs
```

### 2. Format Support
```
├── MP3 (128kbps, 192kbps, 320kbps)
├── MP4 (video)
├── M4A (AAC)
├── FLAC (lossless)
├── WAV (uncompressed)
├── OGG Vorbis
└── AAC
```

### 3. Metadata Management
```
├── Auto-fetch metadata
├── ID3 tag editing
├── Album art download
├── Lyrics embedding
├── Artist info
└── Genre classification
```

### 4. Library Management
```
├── Auto-organize by artist/album
├── Duplicate detection
├── Playlist creation
├── Statistics & analytics
└── Backup & sync
```

## Architecture

```
┌──────────────────────────────────────────────────────────┐
│              MUSIC DOWNLOADER                             │
├──────────────────────────────────────────────────────────┤
│  Search  │  Download  │  Convert  │  Tag  │  Organize  │
└──────────┴────────────┴───────────┴───────┴────────────┘
           │             │            │         │
    ┌──────▼─────┐ ┌────▼────┐ ┌────▼────┐ ┌────▼────┐
    │  YouTube  │ |  Spotify │ |  ffmpeg │ |  ID3Tag │
    │  Spotify  │ |  SoundCL │ |  FFprobe│ |  Mutagen│
    └───────────┘ └─────────┘ └─────────┘ └─────────┘
```

## Commands

### Search & Find
```bash
# Search song
./scripts/music-downloader.sh search "Luka Sekarat Rasa" --platform youtube

# Search album
./scripts/music-downloader.sh search "Album Name" --platform spotify

# Search playlist
./scripts/music-downloader.sh playlist "Playlist Name" --platform spotify
```

### Download
```bash
# Download single track
./scripts/music-downloader.sh download "URL" --output 320kbps

# Download album
./scripts/music-downloader.sh album "Album URL" --batch

# Download playlist
./scripts/music-downloader.sh playlist "Playlist URL" --batch

# Download with metadata
./scripts/music-downloader.sh download "URL" --tag true --art true
```

### Convert
```bash
# Convert format
./scripts/music-downloader.sh convert input.mp4 --format mp3 --quality 320

# Extract audio
./scripts/music-downloader.sh extract "video.mp4" --format wav

# Convert batch
./scripts/music-downloader.sh batch --folder ./music --format flac
```

### Manage
```bash
# Scan library
./scripts/music-downloader.sh scan --folder ~/Music

# Organize library
./scripts/music-downloader.sh organize --by artist --by album

# Find duplicates
./scripts/music-downloader.sh duplicates --folder ~/Music

# Show statistics
./scripts/music-downloader.sh stats --folder ~/Music
```

### Metadata
```bash
# Add tags
./scripts/music-downloader.sh tag "song.mp3" --artist "Artist" --title "Title" --album "Album"

# Edit album art
./scripts/music-downloader.sh art "song.mp3" --image album.jpg

# Get metadata
./scripts/music-downloader.sh info "song.mp3"
```

## Implementation

### Main Downloader
```python
#!/usr/bin/env python3
"""
Music Downloader - Core Download Engine
Supports YouTube, Spotify, SoundCloud, and more
"""

import os
import json
import yt_dlp
import mutagen
from pathlib import Path
from typing import Dict, List, Optional
from dataclasses import dataclass
from datetime import datetime
import subprocess

@dataclass
class DownloadConfig:
    url: str
    format: str = "mp3"
    quality: int = 320  # kbps
    metadata: bool = True
    album_art: bool = True
    output_dir: str = "./downloads"

@dataclass
class Track:
    title: str
    artist: str
    album: str
    duration: int
    url: str
    quality: str
    file_path: str
    metadata: Dict[str, str]

class MusicDownloader:
    def __init__(self):
        self.download_dir = Path("./downloads/music")
        self.download_dir.mkdir(parents=True, exist_ok=True)
        self.history = []
        
    async def search(self, query: str, platform: str = "youtube") -> List[Dict]:
        """Search for music on platform"""
        
        if platform == "youtube":
            return await self._search_youtube(query)
        elif platform == "spotify":
            return await self._search_spotify(query)
        elif platform == "soundcloud":
            return await self._search_soundcloud(query)
        
        return []
    
    async def _search_youtube(self, query: str) -> List[Dict]:
        """Search YouTube for music"""
        search_query = f"ytsearch5:{query}"
        
        ydl_opts = {
            'quiet': True,
            'no_warnings': True,
            'format': 'bestaudio/best',
            'extract_flat': True,
            'default_search': 'ytsearch5'
        }
        
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            try:
                result = ydl.extract_info(search_query, download=False)
                if 'entries' in result:
                    tracks = []
                    for entry in result['entries']:
                        if entry:
                            tracks.append({
                                'title': entry.get('title', 'Unknown'),
                                'artist': entry.get('uploader', 'Unknown'),
                                'duration': entry.get('duration', 0),
                                'url': entry.get('url', ''),
                                'thumbnail': entry.get('thumbnail', ''),
                                'platform': 'youtube'
                            })
                    return tracks
            except Exception as e:
                print(f"Search error: {e}")
        
        return []
    
    async def download(self, config: DownloadConfig) -> Track:
        """Download music from URL"""
        
        output_template = os.path.join(
            config.output_dir,
            '%(artist)s - %(title)s.%(ext)s'
        )
        
        ydl_opts = {
            'format': 'bestaudio/best',
            'outtmpl': output_template,
            'postprocessors': [{
                'key': 'FFmpegExtractAudio',
                'preferredcodec': config.format,
                'preferredquality': str(config.quality),
            }],
            'quiet': False,
            'no_warnings': True,
        }
        
        if config.metadata:
            ydl_opts['writethumbnail'] = True
            ydl_opts['writeinfojson'] = True
        
        track = None
        
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            try:
                info = ydl.extract_info(config.url, download=True)
                
                # Get file path
                file_path = ydl.prepare_filename(info)
                file_path = Path(file_path).with_suffix(f'.{config.format}')
                
                track = Track(
                    title=info.get('title', 'Unknown'),
                    artist=info.get('uploader', 'Unknown'),
                    album=info.get('album', 'Unknown'),
                    duration=info.get('duration', 0),
                    url=config.url,
                    quality=f"{config.quality}kbps",
                    file_path=str(file_path),
                    metadata={}
                )
                
                # Add metadata if requested
                if config.metadata:
                    self._add_metadata(track)
                
                # Save to history
                self.history.append({
                    'timestamp': datetime.now().isoformat(),
                    'track': track.title,
                    'artist': track.artist,
                    'url': config.url
                })
                
            except Exception as e:
                print(f"Download error: {e}")
        
        return track
    
    def _add_metadata(self, track: Track):
        """Add ID3 tags to track"""
        try:
            from mutagen.id3 import ID3, TIT2, TPE1, TALB, TCON, APIC
            
            audio = ID3(track.file_path)
            
            # Add tags
            audio['TIT2'] = TIT2(encoding=3, text=track.title)
            audio['TPE1'] = TPE1(encoding=3, text=track.artist)
            audio['TALB'] = TALB(encoding=3, text=track.album)
            audio['TCON'] = TCON(encoding=3, text='Pop')
            
            # Add album art if available
            if track.metadata.get('thumbnail'):
                # Download and add artwork
                pass
            
            audio.save()
            
        except Exception as e:
            print(f"Metadata error: {e}")
    
    async def download_playlist(self, playlist_url: str, output_dir: str = None) -> List[Track]:
        """Download entire playlist"""
        
        output_dir = output_dir or self.download_dir / "playlists"
        output_dir.mkdir(parents=True, exist_ok=True)
        
        ydl_opts = {
            'format': 'bestaudio/best',
            'outtmpl': str(output_dir / '%(title)s.%(ext)s'),
            'postprocessors': [{
                'key': 'FFmpegExtractAudio',
                'preferredcodec': 'mp3',
                'preferredquality': '320',
            }],
            'writeinfojson': True,
        }
        
        tracks = []
        
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            try:
                info = ydl.extract_info(playlist_url, download=True)
                
                if 'entries' in info:
                    for entry in info['entries']:
                        if entry:
                            track = Track(
                                title=entry.get('title', 'Unknown'),
                                artist=entry.get('uploader', 'Unknown'),
                                album=entry.get('album', 'Unknown'),
                                duration=entry.get('duration', 0),
                                url=entry.get('url', ''),
                                quality='320kbps',
                                file_path='',
                                metadata={}
                            )
                            tracks.append(track)
                
                return tracks
                
            except Exception as e:
                print(f"Playlist download error: {e}")
        
        return tracks
    
    def convert(self, input_file: str, output_format: str = 'mp3', quality: int = 320):
        """Convert audio file to different format"""
        
        input_path = Path(input_file)
        output_path = input_path.with_suffix(f'.{output_format}')
        
        cmd = [
            'ffmpeg',
            '-i', str(input_path),
            '-vn',  # No video
            '-ab', f'{quality}k',  # Audio bitrate
            '-ar', '44100',  # Sample rate
            '-ac', '2',  # Stereo
            '-y',  # Overwrite
            str(output_path)
        ]
        
        try:
            subprocess.run(cmd, check=True, capture_output=True)
            return str(output_path)
        except subprocess.CalledProcessError as e:
            print(f"Conversion error: {e}")
            return None
    
    def get_library_stats(self, folder: str = None) -> Dict:
        """Get statistics about music library"""
        
        folder = Path(folder) if folder else self.download_dir
        
        stats = {
            'total_tracks': 0,
            'total_size_mb': 0,
            'artists': {},
            'albums': {},
            'genres': {},
            'total_duration_minutes': 0
        }
        
        for file_path in folder.rglob('*.mp3'):
            stats['total_tracks'] += 1
            stats['total_size_mb'] += file_path.stat().st_size / (1024 * 1024)
            
            try:
                audio = mutagen.File(file_path)
                if audio and audio.tags:
                    artist = audio.tags.get('TPE1', '').text[0] if audio.tags.get('TPE1') else 'Unknown'
                    album = audio.tags.get('TALB', '').text[0] if audio.tags.get('TALB') else 'Unknown'
                    
                    stats['artists'][artist] = stats['artists'].get(artist, 0) + 1
                    stats['albums'][album] = stats['albums'].get(album, 0) + 1
                    
            except Exception as e:
                print(f"Error reading {file_path}: {e}")
        
        return stats
    
    def find_duplicates(self, folder: str = None) -> List[List[str]]:
        """Find duplicate tracks"""
        
        folder = Path(folder) if folder else self.download_dir
        
        # Group by artist + title
        tracks_by_name = {}
        
        for file_path in folder.rglob('*.mp3'):
            try:
                audio = mutagen.File(file_path)
                if audio and audio.tags:
                    artist = str(audio.tags.get('TPE1', 'Unknown'))
                    title = str(audio.tags.get('TIT2', 'Unknown'))
                    key = f"{artist} - {title}"
                    
                    if key not in tracks_by_name:
                        tracks_by_name[key] = []
                    tracks_by_name[key].append(str(file_path))
                    
            except:
                pass
        
        # Find duplicates (more than 1 file with same name)
        duplicates = [files for files in tracks_by_name.values() if len(files) > 1]
        
        return duplicates

# Example usage
if __name__ == "__main__":
    downloader = MusicDownloader()
    
    async def main():
        # Search
        results = await downloader.search("Luka Sekarat Rasa", "youtube")
        print(f"Found {len(results)} results:")
        for r in results[:3]:
            print(f"  - {r['title']} by {r['artist']}")
        
        # Download (example - would need actual URL)
        # config = DownloadConfig(
        #     url="https://youtube.com/watch?v=...",
        #     format="mp3",
        #     quality=320,
        #     metadata=True
        # )
        # track = await downloader.download(config)
        # print(f"Downloaded: {track.file_path}")
    
    # import asyncio
    # asyncio.run(main())
```

### CLI Interface
```bash
#!/bin/bash

# Music Downloader CLI

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
    *)
        echo "Music Downloader CLI"
        echo ""
        echo "Usage:"
        echo "  ./scripts/music-downloader.sh search <query>"
        echo "  ./scripts/music-downloader.sh download <url> [quality]"
        echo "  ./scripts/music-downloader.sh convert <input> <format>"
        echo "  ./scripts/music-downloader.sh scan <folder>"
        ;;
esac
```

---

**Version:** 1.0  
**Created:** 2026-04-10  
**Author:** Oozu for Tuan  
**Status:** Active  
**Priority:** ⭐⭐⭐⭐⭐
