#!/usr/bin/env python3
"""Package a skill folder into a .skill file."""
import zipfile
import os
import sys
from pathlib import Path

def package_skill(skill_path, output_dir="skills/custom"):
    """Package skill directory into .skill file."""
    skill_name = os.path.basename(skill_path)
    skill_dir = Path(skill_path)
    
    # Validate SKILL.md exists
    skill_md = skill_dir / "SKILL.md"
    if not skill_md.exists():
        print(f"❌ Error: SKILL.md not found in {skill_name}")
        return False
    
    # Create output path
    output_path = Path(output_dir) / f"{skill_name}.skill"
    
    # Create zip file
    with zipfile.ZipFile(output_path, 'w', zipfile.ZIP_DEFLATED) as zf:
        for file_path in skill_dir.rglob('*'):
            if file_path.is_file():
                arc_name = file_path.relative_to(skill_dir)
                zf.write(file_path, arc_name)
    
    print(f"✅ Packaged {skill_name} → {output_path}")
    return True

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: package_skill.py <skill-folder>")
        sys.exit(1)
    
    package_skill(sys.argv[1])
