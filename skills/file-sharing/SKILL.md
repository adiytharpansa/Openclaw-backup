# File-Sharing-Skill

## Deskripsi
Advanced file sharing dan media sending untuk kirim file (MP3, video, dokumen) langsung ke Telegram, Discord, dan platform lainnya. Mengatasi limitation dengan upload ke storage, generate link, atau send via API.

## Kapan Digunakan
- Kirim file audio (MP3) ke Telegram/Discord
- Upload dan share dokumen
- Kirim video/images dari download
- Share hasil processing
- Bulk file sharing
- Auto-upload to cloud storage

## Fitur Utama

### 1. Direct Messaging
```
├── Send MP3 to Telegram
├── Send Video to Telegram
├── Send Documents to Discord
├── Send Images with caption
└── Send as Document (no compression)
```

### 2. Cloud Storage Integration
```
├── Google Drive upload
├── Dropbox upload
├── OneDrive upload
├── Generate shareable link
└── Auto-delete after download
```

### 3. File Management
```
├── Convert format before sending
├── Compress file size
├── Add thumbnail/artwork
├── Metadata extraction
└── File categorization
```

### 4. Multi-Platform
```
├── Telegram (Bot API)
├── Discord (Webhook/API)
├── WhatsApp (via API)
├── Slack (via API)
└── Custom HTTP endpoints
```

## Architecture

```
┌──────────────────────────────────────────────────────────┐
│              FILE SHARING SYSTEM                          │
├──────────────────────────────────────────────────────────┤
│  Source  │  Process  │  Upload  │  Send    │  Cleanup   │
└──────────┴───────────┴──────────┴──────────┴────────────┘
           │           │           │           │
    ┌──────▼──────┐ ┌─▼────┐ ┌────▼────┐ ┌───▼────┐ ┌────▼────┐
    │ Music DL    │ | FFmpeg| | GDrive  │ |TG API  │ | Purge   │
    │ Browser     │ | Resize| | Upload  │ |Send    │ | Temp    │
    └─────────────┘ └───────┘ └─────────┘ └─────────┘ └─────────┘
```

## Commands

### Send Audio
```bash
# Send MP3 to Telegram
./scripts/file-sharer.sh send-audio --file song.mp3 --chat "channel_id"

# Send with thumbnail
./scripts/file-sharer.sh send-audio --file song.mp3 --art cover.jpg --caption "Lagu: Luka Sekarat Rasa"

# Send as document (no compression)
./scripts/file-sharer.sh send-audio --file song.mp3 --as-document
```

### Send Video
```bash
# Send video to Telegram
./scripts/file-sharer.sh send-video --file video.mp4 --caption "Video description"

# Send with thumbnail
./scripts/file-sharer.sh send-video --file video.mp4 --thumbnail thumb.jpg
```

### Send Document
```bash
# Send document
./scripts/file-sharer.sh send-doc --file report.pdf --caption "Dokumen penting"

# Send multiple files
./scripts/file-sharer.sh send-doc --files file1.pdf file2.docx --zip true
```

### Upload to Cloud
```bash
# Upload to Google Drive
./scripts/file-sharer.sh upload --to gdrive --file song.mp3

# Get shareable link
./scripts/file-sharer.sh link --file song.mp3 --platform gdrive

# Upload to Dropbox
./scripts/file-sharer.sh upload --to dropbox --file song.mp3
```

### Manage Uploads
```bash
# List pending uploads
./scripts/file-sharer.sh list

# Delete uploaded files
./scripts/file-sharer.sh delete --id upload_id

# Clean up temp files
./scripts/file-sharer.sh cleanup --older 1d
```

## Implementation

### Main File Sharer
```python
#!/usr/bin/env python3
"""
File Sharing & Media Sender
Send files to Telegram, Discord, and cloud storage
"""

import os
import json
import asyncio
import aiohttp
from pathlib import Path
from typing import Dict, List, Optional, Any
from dataclasses import dataclass, field
from datetime import datetime, timedelta
from enum import Enum
import hashlib
import zipfile

class Platform(Enum):
    TELEGRAM = "telegram"
    DISCORD = "discord"
    GOOGLE_DRIVE = "gdrive"
    DROPBOX = "dropbox"
    ONEDRIVE = "onedrive"
    CLOUDINARY = "cloudinary"

@dataclass
class FileMetadata:
    id: str
    filename: str
    file_path: str
    size_bytes: int
    mime_type: str
    uploaded_at: datetime
    upload_id: Optional[str] = None
    public_url: Optional[str] = None
    platform: Optional[str] = None
    expires_at: Optional[datetime] = None
    caption: Optional[str] = None
    metadata: Dict[str, Any] = field(default_factory=dict)

@dataclass
class SendConfig:
    file_path: str
    platform: Platform
    chat_id: Optional[str] = None
    caption: Optional[str] = None
    as_document: bool = False
    thumbnail: Optional[str] = None
    duration: Optional[int] = None
    performers: Optional[str] = None
    title: Optional[str] = None

class FileSharer:
    def __init__(self, config_dir: str = "./.file-sharer"):
        self.config_dir = Path(config_dir)
        self.config_dir.mkdir(parents=True, exist_ok=True)
        self.temp_dir = Path("./.file-sharer/temp")
        self.temp_dir.mkdir(parents=True, exist_ok=True)
        self.files_db = self._load_files_db()
        
        # Load credentials
        self.telegram_token = os.getenv("TELEGRAM_BOT_TOKEN")
        self.discord_webhook = os.getenv("DISCORD_WEBHOOK_URL")
        
    def _load_files_db(self) -> List[FileMetadata]:
        """Load files database"""
        db_file = self.config_dir / "files_db.json"
        if db_file.exists():
            with open(db_file, 'r') as f:
                return json.load(f)
        return []
    
    def _save_files_db(self):
        """Save files database"""
        db_file = self.config_dir / "files_db.json"
        with open(db_file, 'w') as f:
            json.dump([self._metadata_to_dict(f) for f in self.files_db], f, indent=2)
    
    def _metadata_to_dict(self, meta: FileMetadata) -> dict:
        """Convert metadata to dict"""
        return {
            'id': meta.id,
            'filename': meta.filename,
            'file_path': meta.file_path,
            'size_bytes': meta.size_bytes,
            'mime_type': meta.mime_type,
            'uploaded_at': meta.uploaded_at.isoformat(),
            'upload_id': meta.upload_id,
            'public_url': meta.public_url,
            'platform': meta.platform,
            'expires_at': meta.expires_at.isoformat() if meta.expires_at else None,
            'caption': meta.caption,
            'metadata': meta.metadata
        }
    
    def _dict_to_metadata(self, d: dict) -> FileMetadata:
        """Convert dict to metadata"""
        return FileMetadata(
            id=d['id'],
            filename=d['filename'],
            file_path=d['file_path'],
            size_bytes=d['size_bytes'],
            mime_type=d['mime_type'],
            uploaded_at=datetime.fromisoformat(d['uploaded_at']),
            upload_id=d.get('upload_id'),
            public_url=d.get('public_url'),
            platform=d.get('platform'),
            expires_at=datetime.fromisoformat(d['expires_at']) if d.get('expires_at') else None,
            caption=d.get('caption'),
            metadata=d.get('metadata', {})
        )
    
    def register_file(self, file_path: str, caption: str = None) -> FileMetadata:
        """Register a file for sharing"""
        path = Path(file_path)
        
        file_hash = hashlib.md5(file_path.encode()).hexdigest()[:12]
        meta = FileMetadata(
            id=f"file-{file_hash}-{int(datetime.now().timestamp())}",
            filename=path.name,
            file_path=str(path.absolute()),
            size_bytes=path.stat().st_size,
            mime_type=self._get_mime_type(path),
            uploaded_at=datetime.now(),
            caption=caption
        )
        
        self.files_db.append(meta)
        self._save_files_db()
        
        return meta
    
    def _get_mime_type(self, path: Path) -> str:
        """Get MIME type from file extension"""
        ext = path.suffix.lower()
        mime_map = {
            '.mp3': 'audio/mpeg',
            '.mp4': 'video/mp4',
            '.jpg': 'image/jpeg',
            '.jpeg': 'image/jpeg',
            '.png': 'image/png',
            '.gif': 'image/gif',
            '.pdf': 'application/pdf',
            '.zip': 'application/zip',
            '.rar': 'application/x-rar-compressed'
        }
        return mime_map.get(ext, 'application/octet-stream')
    
    async def send_to_telegram(self, config: SendConfig) -> Dict:
        """Send file to Telegram"""
        
        tg_url = f"https://api.telegram.org/bot{self.telegram_token}"
        
        # Prepare file
        file_path = config.file_path
        thumb = config.thumbnail or None
        
        # Determine API endpoint
        if config.as_document or 'audio' not in config.caption:
            # Send as document
            api_url = f"{tg_url}/sendDocument"
            method = 'document'
        else:
            # Send as audio
            api_url = f"{tg_url}/sendAudio"
            method = 'audio'
        
        # Prepare multipart form data
        data = {
            'chat_id': config.chat_id,
        }
        
        if config.caption:
            data['caption'] = config.caption
        
        if config.duration:
            data['duration'] = config.duration
        
        if config.performers:
            data['performer'] = config.performers
        
        if config.title:
            data['title'] = config.title
        
        files = {
            'filename': (os.path.basename(file_path), open(file_path, 'rb'))
        }
        
        if thumb:
            files['thumb'] = (os.path.basename(thumb), open(thumb, 'rb'), 'image/jpeg')
        
        async with aiohttp.ClientSession() as session:
            async with session.post(api_url, data=data, files=files) as response:
                result = await response.json()
                
                if result.get('ok'):
                    return {
                        'success': True,
                        'file_id': result['result'].get('file_id'),
                        'message_id': result['result'].get('message_id')
                    }
                else:
                    return {
                        'success': False,
                        'error': result.get('description', 'Unknown error')
                    }
    
    async def send_to_discord(self, config: SendConfig) -> Dict:
        """Send file to Discord"""
        
        if not self.discord_webhook:
            return {'success': False, 'error': 'No Discord webhook configured'}
        
        # For Discord, we need to upload to a file hosting service first
        # or use Discord's file upload via webhook
        
        # Upload to temporary cloud storage
        upload_result = await self._upload_to_temp_storage(config.file_path)
        
        if not upload_result.get('success'):
            return upload_result
        
        # Send message with file
        message_data = {
            'content': config.caption or '',
            'embeds': [{
                'title': config.title or config.filename,
                'description': config.caption,
                'url': upload_result['url'],
                'color': 3447003
            }]
        }
        
        async with aiohttp.ClientSession() as session:
            async with session.post(self.discord_webhook, json=message_data) as response:
                if response.status == 204:
                    return {
                        'success': True,
                        'url': upload_result['url']
                    }
                else:
                    return {
                        'success': False,
                        'error': f'Discord API error: {response.status}'
                    }
    
    async def _upload_to_temp_storage(self, file_path: str) -> Dict:
        """Upload file to temporary storage (e.g., file.io)"""
        
        api_url = "https://file.io"
        
        with open(file_path, 'rb') as f:
            files = {'file': f}
            data = {'expires': '1d'}
            
            async with aiohttp.ClientSession() as session:
                async with session.post(api_url, files=files, data=data) as response:
                    result = await response.json()
                    
                    if result.get('success'):
                        return {
                            'success': True,
                            'url': result.get('link'),
                            'expires': result.get('expires')
                        }
                    else:
                        return {
                            'success': False,
                            'error': result.get('message', 'Upload failed')
                        }
    
    async def send_audio_file(self, file_path: str, chat_id: str, 
                              caption: str = None, 
                              duration: int = None,
                              performer: str = None,
                              title: str = None,
                              as_document: bool = False) -> Dict:
        """Send audio file to Telegram with metadata"""
        
        # Register file
        meta = self.register_file(file_path, caption)
        
        # Create config
        config = SendConfig(
            file_path=file_path,
            platform=Platform.TELEGRAM,
            chat_id=chat_id,
            caption=caption,
            as_document=as_document,
            duration=duration,
            performers=performer,
            title=title
        )
        
        # Send
        result = await self.send_to_telegram(config)
        
        if result.get('success'):
            # Update metadata
            meta.public_url = f"https://t.me/{chat_id}"
            meta.upload_id = result.get('file_id')
            meta.platform = Platform.TELEGRAM.value
            self._save_files_db()
        
        return result
    
    async def send_video_file(self, file_path: str, chat_id: str,
                              caption: str = None,
                              thumbnail: str = None) -> Dict:
        """Send video file to Telegram"""
        
        meta = self.register_file(file_path, caption)
        
        config = SendConfig(
            file_path=file_path,
            platform=Platform.TELEGRAM,
            chat_id=chat_id,
            caption=caption,
            thumbnail=thumbnail
        )
        
        # Send video
        tg_url = f"https://api.telegram.org/bot{self.telegram_token}"
        
        files = {
            'video': (os.path.basename(file_path), open(file_path, 'rb'))
        }
        
        data = {
            'chat_id': chat_id,
            'caption': caption or ''
        }
        
        if thumbnail:
            files['thumb'] = (os.path.basename(thumbnail), open(thumbnail, 'rb'), 'image/jpeg')
        
        async with aiohttp.ClientSession() as session:
            async with session.post(f"{tg_url}/sendVideo", data=data, files=files) as response:
                result = await response.json()
                
                if result.get('ok'):
                    meta.public_url = f"https://t.me/{chat_id}"
                    meta.upload_id = result['result'].get('file_id')
                    meta.platform = Platform.TELEGRAM.value
                    self._save_files_db()
                    return {
                        'success': True,
                        'file_id': result['result'].get('file_id')
                    }
                else:
                    return {
                        'success': False,
                        'error': result.get('description')
                    }
    
    def get_files_list(self, days: int = 7) -> List[Dict]:
        """Get list of recently shared files"""
        
        cutoff = datetime.now() - timedelta(days=days)
        
        recent_files = [
            self._metadata_to_dict(f) 
            for f in self.files_db 
            if f.uploaded_at > cutoff
        ]
        
        return sorted(recent_files, key=lambda x: x['uploaded_at'], reverse=True)
    
    def cleanup_old_files(self, older_than_days: int = 1):
        """Clean up temporary files older than X days"""
        
        cutoff = datetime.now() - timedelta(days=older_than_days)
        
        files_to_delete = [
            f for f in self.files_db 
            if f.uploaded_at < cutoff and f.file_path.startswith(str(self.temp_dir))
        ]
        
        for meta in files_to_delete:
            try:
                if Path(meta.file_path).exists():
                    Path(meta.file_path).unlink()
                self.files_db.remove(meta)
            except Exception as e:
                print(f"Error deleting {meta.file_path}: {e}")
        
        self._save_files_db()
    
    def generate_share_link(self, file_id: str) -> Optional[str]:
        """Generate shareable link for file"""
        
        file_meta = next((f for f in self.files_db if f.id == file_id), None)
        
        if not file_meta:
            return None
        
        if file_meta.platform == Platform.TELEGRAM.value:
            return f"https://t.me/c/{file_meta.upload_id}"
        elif file_meta.public_url:
            return file_meta.public_url
        
        return None

# Example usage
if __name__ == "__main__":
    sharer = FileSharer()
    
    # Example: Send audio file
    # asyncio.run(sharer.send_audio_file(
    #     file_path="downloads/music/song.mp3",
    #     chat_id="-1001234567890",
    #     caption="🎵 Luka Sekarat Rasa - Arief",
    #     duration=322,
    #     performer="Arief",
    #     title="Luka Sekarat Rasa"
    # ))
```

### CLI Interface
```bash
#!/bin/bash

# File Sharing CLI

case "$1" in
    send-audio)
        python3 scripts/file-sharer/send_audio.py "$2" "$3" "$4"
        ;;
    send-video)
        python3 scripts/file-sharer/send_video.py "$2" "$3" "$4"
        ;;
    send-doc)
        python3 scripts/file-sharer/send_doc.py "$2" "$3"
        ;;
    upload)
        python3 scripts/file-sharer/upload.py "$2" "$3"
        ;;
    list)
        python3 scripts/file-sharer/list.py
        ;;
    cleanup)
        python3 scripts/file-sharer/cleanup.py "$2"
        ;;
    link)
        python3 scripts/file-sharer/link.py "$2"
        ;;
    *)
        echo "📁 File Sharing CLI"
        echo ""
        echo "Usage:"
        echo "  ./scripts/file-sharer.sh send-audio <file> <chat_id> [caption]"
        echo "  ./scripts/file-sharer.sh send-video <file> <chat_id> [caption]"
        echo "  ./scripts/file-sharer.sh send-doc <file> <caption>"
        echo "  ./scripts/file-sharer.sh upload <file> <platform>"
        echo "  ./scripts/file-sharer.sh list"
        echo "  ./scripts/file-sharer.sh cleanup <days>"
        echo "  ./scripts/file-sharer.sh link <file_id>"
        ;;
esac
```

---

**Version:** 1.0  
**Created:** 2026-04-10  
**Author:** Oozu for Tuan  
**Status:** Active  
**Priority:** ⭐⭐⭐⭐⭐
