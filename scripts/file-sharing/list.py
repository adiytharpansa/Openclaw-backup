#!/usr/bin/env python3
"""List recently shared files"""

import sys
import os

sys.path.insert(0, '/mnt/data/openclaw/workspace/.openclaw/workspace')

from file_sharing.file_sharer import FileSharer

sharer = FileSharer()

files = sharer.get_files_list(days=7)

if not files:
    print("📋 No files shared recently")
    sys.exit(0)

print("📋 Recently Shared Files (last 7 days):")
print("=" * 80)
print(f"{'ID':<25} {'File':<30} {'Size':<10} {'Platform':<12} {'Date'}")
print("-" * 80)

for f in files[:10]:  # Show last 10
    size_mb = f['size_bytes'] / (1024 * 1024)
    print(f"{f['id']:<25} {f['filename']:<30} {size_mb:.1f} MB  {f['platform']:<12} {f['uploaded_at'][:10]}")

print("-" * 80)
print(f"Total: {len(files)} files")
