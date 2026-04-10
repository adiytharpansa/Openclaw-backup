#!/usr/bin/env python3
"""
Email Checker for OpenClaw
Check Gmail periodically and notify via Telegram
"""

import imaplib
import email
import smtplib
from email.mime.text import MIMEText
import json
import time
import os

CONFIG_FILE = "/mnt/data/openclaw/workspace/.openclaw/workspace/.himalaya.toml"
LOG_FILE = "/mnt/data/openclaw/workspace/.openclaw/workspace/email_checker.log"
STATE_FILE = "/mnt/data/openclaw/workspace/.openclaw/workspace/email_state.json"

TELEGRAM_BOT_TOKEN = "8038502164:AAEw1AQ1dpBY6G--j5udIRCHjUyNpk-CZxY"
TELEGRAM_CHAT_ID = "6023537487"  # Your user ID

def parse_config():
    config = {}
    try:
        with open(CONFIG_FILE, 'r') as f:
            content = f.read()
        for line in content.split('\n'):
            line = line.strip()
            if '=' in line and not line.startswith('#') and not line.startswith('['):
                key, value = line.split('=', 1)
                config[key.strip()] = value.strip().strip('"')
    except Exception as e:
        print(f"Config error: {e}")
    return config

def send_telegram(message):
    """Send message to Telegram"""
    url = f"https://api.telegram.org/bot{TELEGRAM_BOT_TOKEN}/sendMessage"
    payload = {
        "chat_id": TELEGRAM_CHAT_ID,
        "text": message,
        "parse_mode": "HTML"
    }
    import urllib.request
    try:
        req = urllib.request.Request(url, 
            data=json.dumps(payload).encode('utf-8'),
            headers={'Content-Type': 'application/json'})
        urllib.request.urlopen(req)
        return True
    except Exception as e:
        print(f"Telegram error: {e}")
        return False

def load_state():
    try:
        with open(STATE_FILE, 'r') as f:
            return json.load(f)
    except:
        return {"last_checked": 0, "last_email_id": None, "processed_emails": []}

def save_state(state):
    with open(STATE_FILE, 'w') as f:
        json.dump(state, f)

def check_email():
    config = parse_config()
    
    if not config.get('pass') or config.get('pass') == '':
        send_telegram("⚠️ <b>Email Checker Setup Required!</b>\n\nPlease add Gmail App Password to .himalaya.toml")
        return
    
    try:
        mail = imaplib.IMAP4_SSL(config.get('host', 'imap.gmail.com'), int(config.get('port', 993)))
        mail.login(config.get('user'), config.get('pass'))
        mail.select('inbox')
        
        status, messages = mail.search(None, 'ALL')
        email_ids = messages[0].split()
        
        state = load_state()
        new_emails = []
        
        for eid in email_ids:
            if eid in state['processed_emails']:
                continue
            
            status, msg = mail.fetch(eid, '(RFC822)')
            email_msg = email.message_from_bytes(msg[0][1])
            
            subject = email_msg.get('Subject', 'No Subject')
            sender = email_msg.get('From', 'Unknown')
            date = email_msg.get('Date', 'Unknown')
            
            body = ""
            if email_msg.is_multipart():
                for part in email_msg.walk():
                    if part.get_content_type() == "text/plain":
                        try:
                            body = part.get_payload(decode=True).decode('utf-8', errors='ignore')[:100]
                        except:
                            pass
                        break
            else:
                try:
                    body = email_msg.get_payload(decode=True).decode('utf-8', errors='ignore')[:100]
                except:
                    pass
            
            # Check if important
            important_keywords = ['urgent', 'important', 'meeting', 'deadline', 'invoice', 'payment']
            is_important = any(kw in subject.lower() or sender.lower() for kw in important_keywords)
            
            email_info = {
                'id': eid.decode(),
                'subject': subject,
                'from': sender,
                'date': date,
                'body': body,
                'important': is_important
            }
            
            new_emails.append(email_info)
            state['processed_emails'].append(eid.decode())
        
        mail.close()
        mail.logout()
        
        # Send notification
        if new_emails:
            message = f"📧 <b>Email Notification!</b>\n\n"
            message += f"<b>{len(new_emails)} new email(s)</b>\n\n"
            
            for email_info in new_emails[-3:]:  # Show last 3
                important_badge = "🔥 " if email_info['important'] else ""
                message += f"• {important_badge}{email_info['subject']}\n"
                message += f"  From: {email_info['from']}\n"
                message += f"  Date: {email_info['date']}\n\n"
            
            message += "<i>Reply to this message to mark as read or ignore</i>"
            
            send_telegram(message)
            print(f"Sent notification: {len(new_emails)} emails")
        else:
            print("No new emails")
        
        state['last_checked'] = time.time()
        save_state(state)
        
    except Exception as e:
        error_msg = f"❌ <b>Email Check Failed!</b>\n\nError: {str(e)}\n\nCheck your App Password!"
        send_telegram(error_msg)
        print(f"Error: {e}")

if __name__ == '__main__':
    import sys
    
    if len(sys.argv) > 1 and sys.argv[1] == '--daemon':
        print("Email checker running in daemon mode...")
        print("Press Ctrl+C to stop")
        
        while True:
            try:
                check_email()
                time.sleep(300)  # Check every 5 minutes
            except KeyboardInterrupt:
                print("Stopped!")
                break
            except Exception as e:
                print(f"Error in loop: {e}")
                time.sleep(60)
    else:
        check_email()
