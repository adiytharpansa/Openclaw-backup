# telegram-optimizer

Optimasi OpenClaw untuk Telegram messaging.

## Features

- ✅ Auto-format untuk Telegram (Markdown, emoji)
- ✅ Inline buttons support
- ✅ Reply threading
- ✅ Media handling (images, files, voice)
- ✅ Proactive notifications
- ✅ Auto-reply patterns

## Telegram-Specific Optimizations

### Message Formatting
```
✅ Supports: Markdown, HTML, emoji
✅ Max length: 4096 characters
✅ Inline buttons: Up to 100 per message
✅ Reply support: Yes
```

### Best Practices
1. **Short messages** - Break long text into chunks
2. **Use emoji** - More engaging
3. **Inline buttons** - For quick actions
4. **Reply threading** - Keep context
5. **Media as files** - Avoid compression

### Notification Types
| Type | Format | Priority |
|------|--------|----------|
| Alert | 🚨 + bold | High |
| Info | ℹ️ + normal | Medium |
| Success | ✅ + normal | Low |
| Error | ❌ + bold | High |

## Usage

```bash
# Send optimized Telegram message
skills/telegram-optimizer/send.sh "Message"

# Send with buttons
skills/telegram-optimizer/send.sh --buttons "Label:callback" "Message"

# Send media
skills/telegram-optimizer/send.sh --media path/to/file.jpg "Caption"
```

## Related
- `openclaw-whatsapp` skill - WhatsApp bridge
- `message` tool - Native Telegram support
