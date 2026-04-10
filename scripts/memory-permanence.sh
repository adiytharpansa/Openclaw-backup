#!/bin/bash

# Memory Permanence System - Main Script
# Untuk enhanced memory dan permanent knowledge

set -e

MEMORY_BASE="/mnt/data/openclaw/workspace/.openclaw/workspace"
MEMORY_DIR="$MEMORY_BASE/memory"
DAILY_LOG="$MEMORY_DIR/$(date +%Y-%m-%d).md"
LONG_TERM="$MEMORY_BASE/MEMORY.md"
GIT_DIR="$MEMORY_BASE"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Initialize directories
init_dirs() {
    mkdir -p "$MEMORY_DIR/permanent"
    mkdir -p "$MEMORY_DIR/skills"
    mkdir -p "$MEMORY_DIR/relationships"
    mkdir -p "$MEMORY_DIR/projects"
}

# Save memory with category and priority
save_memory() {
    local content="$1"
    local category="${2:-general}"
    local priority="${3:-normal}"
    local timestamp=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
    local session_id=$(uuidgen 2>/dev/null || cat /proc/sys/kernel/random/uuid | tr -d '\n')
    
    echo -e "${BLUE}[MEMORY-SAVE]${NC} Saving: $content"
    
    # Create daily log header if doesn't exist
    if [ ! -f "$DAILY_LOG" ]; then
        echo "# Memory - $(date +'%A, %B %d, %Y')" > "$DAILY_LOG"
        echo "" >> "$DAILY_LOG"
        echo "## Today's Learnings and Context" >> "$DAILY_LOG"
        echo "" >> "$DAILY_LOG"
    fi
    
    # Append to daily log with timestamp and metadata
    # Append to daily log with timestamp and metadata
    echo "- **[$timestamp] [$category]** $content **(ID: $session_id)**" >> "$DAILY_LOG"
    
    # If high priority, add to long-term memory
    if [ "$priority" = "high" ]; then
        # Check if category exists in long-term memory
        if ! grep -q "# $category" "$LONG_TERM" 2>/dev/null; then
            echo "" >> "$LONG_TERM"
            echo "## $category" >> "$LONG_TERM"
            echo "" >> "$LONG_TERM"
        fi
        
        # Add to appropriate section
        echo "- **$content** (Added: $timestamp, ID: $session_id)" >> "$LONG_TERM"
        echo -e "${GREEN}[MEMORY-SAVE]${NC} Added to long-term memory (permanent)"
    fi
    
    # Create skill-specific memory if applicable
    if [ "$category" = "skills" ]; then
        skill_name=$(echo "$1" | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9_-')
        skill_mem="$MEMORY_DIR/skills/$skill_name.md"
        if [ ! -f "$skill_mem" ]; then
            echo "# $category - $skill_name" > "$skill_mem"
            echo "" >> "$skill_mem"
            echo "## Learning Log" >> "$skill_mem"
            echo "" >> "$skill_mem"
        fi
        echo "### $(date +%Y-%m-%d)" >> "$skill_mem"
        echo "- $content" >> "$skill_mem"
        echo "" >> "$skill_mem"
        echo -e "${GREEN}[MEMORY-SAVE]${NC} Added to skill-specific memory"
    fi
    
    # Git commit all changes
    cd "$GIT_DIR"
    git add -A
    git diff-index --quiet HEAD || git commit -m "[MEMORY] $content"
    
    echo -e "${GREEN}✅ Memory saved and committed!${NC}"
}

# Search memory
search_memory() {
    local query="$1"
    local category="${2:-all}"
    
    echo -e "${BLUE}[MEMORY-SEARCH]${NC} Searching for: $query"
    
    local results=""
    if [ "$category" = "all" ]; then
        results=$(grep -rn "$query" "$MEMORY_DIR" "$LONG_TERM" --include="*.md" 2>/dev/null || true)
    else
        results=$(grep -rn "$query" "$MEMORY_DIR/$category" "$LONG_TERM" --include="*.md" 2>/dev/null || true)
    fi
    
    if [ -n "$results" ]; then
        echo -e "${GREEN}Found memories:${NC}"
        echo "$results"
    else
        echo -e "${YELLOW}No memories found for: $query${NC}"
    fi
}

# Get recent memories
get_recent() {
    local limit="${1:-10}"
    
    echo -e "${BLUE}[MEMORY-RECENT]${NC} Recent memories (last $limit):"
    echo ""
    
    # Get from all daily logs, sorted by date (newest first)
    find "$MEMORY_DIR" -maxdepth 1 -name "*.md" -type f | \
        sort -r | head -20 | \
        while read -r file; do
            # Extract memory entries (lines starting with - **)
            grep -E "^\- \*\*" "$file" 2>/dev/null | head -5 | \
                sed "s|$MEMORY_DIR/||g"
        done | head -20
    
    echo ""
}

# Consolidate daily logs into long-term memory
consolidate() {
    local from_date="${1:-$(date +%Y-%m-%d)}"
    local to_date="${2:-$from_date}"
    local auto="${3:-false}"
    
    echo -e "${BLUE}[MEMORY-CONSOLIDATE]${NC} Reviewing memories from $from_date to $to_date"
    echo ""
    
    local merged=""
    
    for day in $(seq -w 0 0); do
        local day_file="$MEMORY_DIR/${from_date:0:10}.md"
        if [ -f "$day_file" ]; then
            # Extract items marked with ** (high priority)
            items=$(grep -E "^\- \*\*.*\*\*" "$day_file" 2>/dev/null || true)
            if [ -n "$items" ]; then
                merged="$merged$items"$'\n'
            fi
        fi
    done
    
    if [ -n "$merged" ]; then
        echo -e "${GREEN}Items to consolidate:${NC}"
        echo "$merged"
        echo ""
        
        if [ "$auto" = "true" ]; then
            echo -e "${YELLOW}Auto-adding to long-term memory...${NC}"
            echo "$merged" | while read -r item; do
                # Add timestamp
                timestamp=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
                echo "- $item (Consolidated: $timestamp)" >> "$LONG_TERM"
            done
            echo -e "${GREEN}✅ Consolidation complete!${NC}"
            # Git commit
            cd "$GIT_DIR"
            git add -A
            git diff-index --quiet HEAD || git commit -m "[MEMORY] Consolidated from $from_date to $to_date"
        else
            echo -e "${YELLOW}Review complete. Use --auto to add to long-term memory.${NC}"
        fi
    else
        echo -e "${GREEN}No high-priority items to consolidate.${NC}"
    fi
}

# Review pending consolidation
review_pending() {
    echo -e "${BLUE}[MEMORY-REVIEW]${NC} Reviewing daily logs for pending items:"
    echo ""
    
    # Find all daily logs
    for day_file in "$MEMORY_DIR"/*.md; do
        if [ -f "$day_file" ]; then
            # Check if file has items but no consolidation marker
            if grep -q "^\- \*\*" "$day_file" && ! grep -q "## Consolidated" "$day_file"; then
                echo -e "${YELLOW}Pending: $day_file${NC}"
                grep -E "^\- \*\*" "$day_file" | head -5
                echo ""
            fi
        fi
    done
}

# Get category memories
get_category() {
    local category="$1"
    
    echo -e "${BLUE}[MEMORY-CATEGORY]${NC} Memories from category: $category"
    echo ""
    
    # Check if it's a built-in category
    case "$category" in
        preferences|technical|projects|learnings|skills|relationships)
            local file="$MEMORY_DIR/$category.md"
            if [ -f "$file" ]; then
                cat "$file"
            else
                echo -e "${YELLOW}No memories found for category: $category${NC}"
            fi
            ;;
        *)
            # Search for category in all memory files
            grep -rn "$category" "$MEMORY_DIR" "$LONG_TERM" --include="*.md" -A 2 2>/dev/null | head -30
            ;;
    esac
}

# Check memory health
check_health() {
    echo -e "${BLUE}[MEMORY-HEALTH]${NC} Memory System Status:"
    echo ""
    
    local stats=$(cat <<EOF
- Total files in memory: $(find "$MEMORY_DIR" -name "*.md" | wc -l)
- Lines in MEMORY.md: $(wc -l < "$LONG_TERM" 2>/dev/null || echo 0)
- Daily logs this month: $(ls -1 "$MEMORY_DIR"/[0-9][0-9][0-9][0-9]-[0-9][0-9]-*.md 2>/dev/null | wc -l)
- Permanent memories: $(ls -1 "$MEMORY_DIR/permanent"/*.md 2>/dev/null | wc -l)
- Skill memories: $(ls -1 "$MEMORY_DIR/skills"/*.md 2>/dev/null | wc -l)
EOF
)
    
    echo "$stats"
    echo ""
    
    # Check git status
    cd "$GIT_DIR"
    local git_status=$(git status --short 2>/dev/null || echo "")
    if [ -n "$git_status" ]; then
        echo -e "${RED}⚠️ Uncommitted changes detected!${NC}"
        echo "$git_status"
        echo ""
    else
        echo -e "${GREEN}✅ All changes committed${NC}"
    fi
}

# Update skill documentation
update_skill_doc() {
    local skill_name="$1"
    local addition="$2"
    
    local skill_dir="$MEMORY_BASE/skills/$skill_name"
    local skill_readme="$skill_dir/README.md"
    
    if [ ! -d "$skill_dir" ]; then
        echo -e "${RED}Skill directory not found: $skill_dir${NC}"
        return 1
    fi
    
    echo -e "${BLUE}[MEMORY-SKILL]${NC} Updating skill documentation for: $skill_name"
    
    if [ ! -f "$skill_readme" ]; then
        echo "# $skill_name" > "$skill_readme"
        echo "" >> "$skill_readme"
        echo "## Learnings" >> "$skill_readme"
        echo "" >> "$skill_readme"
    fi
    
    local timestamp=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
    echo "### $timestamp" >> "$skill_readme"
    echo "- $addition" >> "$skill_readme"
    echo "" >> "$skill_readme"
    
    echo -e "${GREEN}✅ Skill documentation updated!${NC}"
    
    # Git commit
    cd "$GIT_DIR"
    git add -A
    git diff-index --quiet HEAD || git commit -m "[MEMORY] Updated $skill_name documentation"
}

# Main command handler
case "$1" in
    save)
        init_dirs
        if [ -z "$2" ]; then
            echo "Usage: memory-permanence save \"content\" [category] [priority]"
            exit 1
        fi
        save_memory "$2" "$3" "$4"
        ;;
    search)
        if [ -z "$2" ]; then
            echo "Usage: memory-permanence search \"query\" [category]"
            exit 1
        fi
        search_memory "$2" "$3"
        ;;
    recent)
        get_recent "$2"
        ;;
    consolidate)
        init_dirs
        consolidate "$2" "$3" "$4"
        ;;
    review)
        review_pending
        ;;
    category|cat)
        if [ -z "$2" ]; then
            echo "Usage: memory-permanence category <category>"
            exit 1
        fi
        get_category "$2"
        ;;
    health)
        check_health
        ;;
    update-skill)
        if [ -z "$2" ] || [ -z "$3" ]; then
            echo "Usage: memory-permanence update-skill <skill_name> \"addition\""
            exit 1
        fi
        update_skill_doc "$2" "$3"
        ;;
    *)
        echo -e "${BLUE}Memory Permanence System${NC}"
        echo ""
        echo "Usage: memory-permanence {command} [args]"
        echo ""
        echo "Commands:"
        echo "  save \"content\" [category] [priority]  - Save memory"
        echo "  search \"query\" [category]             - Search memory"
        echo "  recent [limit]                        - Get recent memories"
        echo "  consolidate [from] [to] [--auto]      - Consolidate to long-term"
        echo "  review                                - Review pending consolidation"
        echo "  category <category>                   - Get category memories"
        echo "  health                                - Check memory health"
        echo "  update-skill <skill> \"text\"           - Update skill doc"
        echo ""
        echo "Categories: general, preferences, technical, projects, learnings, skills, relationships"
        echo "Priority: normal, high"
        echo ""
        ;;
esac
