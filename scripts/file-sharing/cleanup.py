#!/usr/bin/env python3
"""Clean up old temporary files"""

import sys
import os

sys.path.insert(0, '/mnt/data/openclaw/workspace/.openclaw/workspace')

from file_sharing.file_sharer import FileSharer

days = int(sys.argv[1]) if len(sys.argv) > 1 else 1

print(f"🧹 Cleaning up files older than {days} day(s)...")

sharer = FileSharer()
sharer.cleanup_old_files(days)

print("✅ Cleanup complete!")
