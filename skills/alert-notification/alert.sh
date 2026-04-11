#!/bin/bash
# alert.sh - Send alerts via multiple channels

TITLE="${1:-Alert}"
MESSAGE="${2:-No message}"
PRIORITY="${3:-info}"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S UTC')

# Config (create if not exists)
CONFIG_FILE="/etc/openclaw/alerts.conf"
if [ ! -f "$CONFIG_FILE" ]; then
    # Use workspace config for sandbox
    CONFIG_FILE="$(dirname "$0")/alerts.conf"
fi

# Load config
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
fi

# Defaults
TELEGRAM_CHAT_ID="${TELEGRAM_CHAT_ID:-}"
TELEGRAM_BOT_TOKEN="${TELEGRAM_BOT_TOKEN:-}"
ENABLE_TELEGRAM="${ENABLE_TELEGRAM:-false}"

# Priority emoji
case "$PRIORITY" in
    critical) EMOJI="🚨" ;;
    warning)  EMOJI="⚠️" ;;
    info)     EMOJI="ℹ️" ;;
    *)        EMOJI="📢" ;;
esac

# Format message
ALERT_MSG="$EMOJI *$TITLE*

$MESSAGE

Time: $TIMESTAMP
Host: $(hostname 2>/dev/null || echo 'unknown')
Priority: $PRIORITY"

# Send to Telegram
send_telegram() {
    if [ "$ENABLE_TELEGRAM" != "true" ]; then
        echo "ℹ️  Telegram disabled"
        return 0
    fi
    
    if [ -z "$TELEGRAM_BOT_TOKEN" ] || [ -z "$TELEGRAM_CHAT_ID" ]; then
        echo "⚠️  Telegram not configured (missing token or chat_id)"
        return 1
    fi
    
    echo "📤 Sending Telegram alert..."
    
    # Use message tool if available (OpenClaw)
    if command -v openclaw &> /dev/null; then
        openclaw message send --channel telegram --target "$TELEGRAM_CHAT_ID" --message "$ALERT_MSG"
    else
        # Fallback to curl
        curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
            -d "chat_id=$TELEGRAM_CHAT_ID" \
            -d "text=$ALERT_MSG" \
            -d "parse_mode=Markdown" > /dev/null
    fi
    
    if [ $? -eq 0 ]; then
        echo "✅ Telegram alert sent"
    else
        echo "❌ Failed to send Telegram alert"
    fi
}

# Send to Discord
send_discord() {
    if [ "${ENABLE_DISCORD:-false}" != "true" ]; then
        echo "ℹ️  Discord disabled"
        return 0
    fi
    
    if [ -z "${DISCORD_WEBHOOK:-}" ]; then
        echo "⚠️  Discord not configured (missing webhook)"
        return 1
    fi
    
    echo "📤 Sending Discord alert..."
    
    # Color based on priority
    case "$PRIORITY" in
        critical) COLOR=16711680 ;;  # Red
        warning)  COLOR=16753920 ;;  # Orange
        info)     COLOR=3066993 ;;   # Green
        *)        COLOR=3447003 ;;   # Blue
    esac
    
    PAYLOAD=$(cat <<EOF
{
  "embeds": [{
    "title": "$TITLE",
    "description": "$MESSAGE",
    "color": $COLOR,
    "footer": {
      "text": "Host: $(hostname 2>/dev/null || echo 'unknown') | Time: $TIMESTAMP"
    }
  }]
}
EOF
)
    
    curl -s -X POST -H "Content-Type: application/json" \
        -d "$PAYLOAD" \
        "$DISCORD_WEBHOOK" > /dev/null
    
    echo "✅ Discord alert sent"
}

# Send to Email
send_email() {
    if [ "${ENABLE_EMAIL:-false}" != "true" ]; then
        echo "ℹ️  Email disabled"
        return 0
    fi
    
    if [ -z "${EMAIL_RECIPIENT:-}" ]; then
        echo "⚠️  Email not configured (missing recipient)"
        return 1
    fi
    
    echo "📤 Sending email alert..."
    
    # Use mail command if available
    if command -v mail &> /dev/null; then
        echo "$MESSAGE" | mail -s "[$PRIORITY] $TITLE" "$EMAIL_RECIPIENT"
        echo "✅ Email alert sent"
    else
        echo "⚠️  mail command not available"
    fi
}

# Log alert
log_alert() {
    LOG_FILE="/var/log/openclaw/alerts.log"
    mkdir -p "$(dirname "$LOG_FILE")" 2>/dev/null
    
    echo "[$TIMESTAMP] [$PRIORITY] $TITLE: $MESSAGE" >> "$LOG_FILE"
}

# Main
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "$EMOJI ALERT: $TITLE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Priority: $PRIORITY"
echo "Message: $MESSAGE"
echo "Time: $TIMESTAMP"
echo ""

# Send to all channels
send_telegram
send_discord
send_email

# Log it
log_alert
echo "✅ Alert logged"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
