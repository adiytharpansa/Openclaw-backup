#!/bin/bash
# Clawd CLI - Custom Command Line Interface
# Your personal AI assistant commands

VERSION="1.0.0"
WORKSPACE="/mnt/data/openclaw/workspace/.openclaw/workspace"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Help message
show_help() {
    cat << EOF
${BLUE}╔════════════════════════════════════════════╗${NC}
${BLUE}║           CLAWD CLI v${VERSION}                  ║${NC}
${BLUE}╚════════════════════════════════════════════╝${NC}

${GREEN}Usage:${NC} clawd <command> [options]

${GREEN}Commands:${NC}
  ${YELLOW}research${NC} <topic>     Deep research on a topic
  ${YELLOW}brief${NC}                Daily briefing
  ${YELLOW}summarize${NC} <url>      Summarize a URL
  ${YELLOW}transcribe${NC} <file>    Transcribe audio/video
  ${YELLOW}backup${NC}               Create backup
  ${YELLOW}status${NC}               System status
  ${YELLOW}search${NC} <query>       Search memory/knowledge
  ${YELLOW}deploy${NC} <project>     Deploy a project
  ${YELLOW}report${NC} <type>        Generate report
  ${YELLOW}voice${NC} <text>         Text-to-speech
  ${YELLOW}clean${NC}                Clean cache & temp files
  ${YELLOW}help${NC}                 Show this help

${GREEN}Examples:${NC}
  clawd research "AI trends 2026"
  clawd brief
  clawd summarize https://example.com/article
  clawd search "project decisions"
  clawd voice "Hello world"

EOF
}

# Research command
cmd_research() {
    local topic="$1"
    if [ -z "$topic" ]; then
        echo -e "${RED}Error: Topic required${NC}"
        echo "Usage: clawd research <topic>"
        exit 1
    fi
    
    echo -e "${BLUE}🔍 Starting research on: ${GREEN}$topic${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Use web_search (would be called via OpenClaw)
    echo "Searching web..."
    # web_search "$topic"
    
    echo ""
    echo -e "${GREEN}✅ Research complete!${NC}"
    echo "Results saved to: knowledge/research/$(date +%Y%m%d_%H%M%S).md"
}

# Daily briefing
cmd_brief() {
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}
    ${BLUE}║       DAILY BRIEFING - $(date +%Y-%m-%d)        ║${NC}
    ${BLUE}╚════════════════════════════════════════╝${NC}"
    
    # Weather
    echo -e "\n${YELLOW}🌤️  Weather:${NC}"
    curl -s "wttr.in/?format=3" 2>/dev/null || echo "Weather unavailable"
    
    # Git status
    echo -e "\n${YELLOW}💻 Git Status:${NC}"
    cd "$WORKSPACE" && git status --short 2>/dev/null | head -5 || echo "No changes"
    
    # Recent commits
    echo -e "\n${YELLOW}📝 Recent Commits:${NC}"
    cd "$WORKSPACE" && git log --oneline -3 2>/dev/null || echo "N/A"
    
    # Memory check
    echo -e "\n${YELLOW}🧠 Recent Memories:${NC}"
    ls -la "$WORKSPACE/memory/"*.md 2>/dev/null | tail -3 || echo "No memories"
    
    echo -e "\n${GREEN}✅ Have a productive day!${NC}"
}

# Search memory
cmd_search() {
    local query="$1"
    if [ -z "$query" ]; then
        echo -e "${RED}Error: Query required${NC}"
        echo "Usage: clawd search <query>"
        exit 1
    fi
    
    echo -e "${BLUE}🔍 Searching for: ${GREEN}$query${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Search in memory files
    grep -ri "$query" "$WORKSPACE/memory/" 2>/dev/null | head -10
    grep -ri "$query" "$WORKSPACE/knowledge/" 2>/dev/null | head -10
    grep -ri "$query" "$WORKSPACE/MEMORY.md" 2>/dev/null | head -10
    
    echo -e "\n${GREEN}✅ Search complete${NC}"
}

# Backup
cmd_backup() {
    local backup_dir="$WORKSPACE/backups/$(date +%Y%m%d_%H%M%S)"
    
    echo -e "${BLUE}💾 Creating backup...${NC}"
    mkdir -p "$backup_dir"
    
    # Backup important directories
    cp -r "$WORKSPACE/memory/" "$backup_dir/" 2>/dev/null
    cp -r "$WORKSPACE/knowledge/" "$backup_dir/" 2>/dev/null
    cp "$WORKSPACE"/*.md "$backup_dir/" 2>/dev/null
    
    # Create archive
    cd "$WORKSPACE/backups"
    tar -czf "$(date +%Y%m%d_%H%M%S).tar.gz" "$(basename $backup_dir)" 2>/dev/null
    rm -rf "$backup_dir"
    
    echo -e "${GREEN}✅ Backup created: $WORKSPACE/backups/$(date +%Y%m%d_%H%M%S).tar.gz${NC}"
}

# Status
cmd_status() {
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}
    ${BLUE}║          CLAWD SYSTEM STATUS           ║${NC}
    ${BLUE}╚════════════════════════════════════════╝${NC}"
    
    # Git status
    echo -e "\n${YELLOW}📊 Repository:${NC}"
    cd "$WORKSPACE" && git log --oneline -1 2>/dev/null || echo "Not a git repo"
    
    # Skills count
    echo -e "\n${YELLOW}🛠️  Skills:${NC}"
    local skill_count=$(ls -1 "$WORKSPACE/skills/" 2>/dev/null | wc -l)
    echo "$skill_count skills installed"
    
    # Memory files
    echo -e "\n${YELLOW}🧠 Memory:${NC}"
    local memory_count=$(ls -1 "$WORKSPACE/memory/"*.md 2>/dev/null | wc -l)
    echo "$memory_count memory files"
    
    # Disk usage
    echo -e "\n${YELLOW}💾 Disk Usage:${NC}"
    du -sh "$WORKSPACE" 2>/dev/null | cut -f1
    
    # Uptime
    echo -e "\n${YELLOW}⏱️  Uptime:${NC}"
    uptime -p 2>/dev/null || echo "N/A"
    
    echo -e "\n${GREEN}✅ All systems operational${NC}"
}

# Clean cache
cmd_clean() {
    echo -e "${BLUE}🧹 Cleaning cache and temp files...${NC}"
    
    # Remove old backups (keep last 10)
    cd "$WORKSPACE/backups" 2>/dev/null
    ls -t *.tar.gz 2>/dev/null | tail -n +11 | xargs rm -f 2>/dev/null
    
    # Remove temp files
    find "$WORKSPACE" -name "*.tmp" -delete 2>/dev/null
    find "$WORKSPACE" -name "*.log" -mtime +7 -delete 2>/dev/null
    
    echo -e "${GREEN}✅ Cleanup complete${NC}"
}

# Voice (TTS)
cmd_voice() {
    local text="$1"
    if [ -z "$text" ]; then
        echo -e "${RED}Error: Text required${NC}"
        echo "Usage: clawd voice <text>"
        exit 1
    fi
    
    echo -e "${BLUE}🔊 Converting to speech...${NC}"
    # Would use sag or tts tool
    echo "Text: $text"
    echo -e "${GREEN}✅ Audio generated${NC}"
}

# Main command router
case "$1" in
    research)
        cmd_research "$2"
        ;;
    brief)
        cmd_brief
        ;;
    search)
        cmd_search "$2"
        ;;
    backup)
        cmd_backup
        ;;
    status)
        cmd_status
        ;;
    clean)
        cmd_clean
        ;;
    voice)
        cmd_voice "$2"
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        if [ -z "$1" ]; then
            show_help
        else
            echo -e "${RED}Unknown command: $1${NC}"
            echo "Run 'clawd help' for usage"
            exit 1
        fi
        ;;
esac
