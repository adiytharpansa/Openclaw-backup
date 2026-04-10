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
