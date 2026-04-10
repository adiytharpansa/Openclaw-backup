#!/usr/bin/env python3
"""
Simple Email CLI for OpenClaw
Supports Gmail IMAP/SMTP
"""

import imaplib
import smtplib
import email
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import json
import sys

CONFIG_FILE = "/mnt/data/openclaw/workspace/.openclaw/workspace/.himalaya.toml"

def parse_config():
    """Parse simple TOML-like config"""
    config = {}
    try:
        with open(CONFIG_FILE, 'r') as f:
            content = f.read()
            
        # Simple parser for our config format
        for line in content.split('\n'):
            line = line.strip()
            if '=' in line and not line.startswith('#') and not line.startswith('['):
                key, value = line.split('=', 1)
                key = key.strip()
                value = value.strip().strip('"')
                config[key] = value
    except Exception as e:
        print(f"Error reading config: {e}")
        sys.exit(1)
    
    return config

def check_inbox(limit=5):
    """Check inbox emails"""
    config = parse_config()
    
    if not config.get('pass'):
        print("ERROR: Password not configured!")
        print("Please add your Gmail App Password to .himalaya.toml")
        sys.exit(1)
    
    try:
        # Connect to IMAP
        mail = imaplib.IMAP4_SSL(config.get('host', 'imap.gmail.com'), int(config.get('port', 993)))
        mail.login(config.get('user'), config.get('pass'))
        mail.select('inbox')
        
        # Search for emails
        status, messages = mail.search(None, 'ALL')
        email_ids = messages[0].split()
        
        # Get latest emails
        emails = []
        for eid in email_ids[-limit:]:
            status, msg = mail.fetch(eid, '(RFC822)')
            email_msg = email.message_from_bytes(msg[0][1])
            
            subject = email_msg.get('Subject', 'No Subject')
            sender = email_msg.get('From', 'Unknown')
            date = email_msg.get('Date', 'Unknown')
            
            # Get body
            body = ""
            if email_msg.is_multipart():
                for part in email_msg.walk():
                    if part.get_content_type() == "text/plain":
                        try:
                            body = part.get_payload(decode=True).decode('utf-8', errors='ignore')[:200]
                        except:
                            pass
                        break
            else:
                try:
                    body = email_msg.get_payload(decode=True).decode('utf-8', errors='ignore')[:200]
                except:
                    pass
            
            emails.append({
                'subject': subject,
                'from': sender,
                'date': date,
                'body': body
            })
        
        mail.close()
        mail.logout()
        
        return emails
        
    except Exception as e:
        print(f"ERROR: {e}")
        sys.exit(1)

def send_email(to, subject, body):
    """Send email via SMTP"""
    config = parse_config()
    
    if not config.get('pass'):
        print("ERROR: Password not configured!")
        sys.exit(1)
    
    try:
        msg = MIMEMultipart()
        msg['From'] = config.get('user')
        msg['To'] = to
        msg['Subject'] = subject
        msg.attach(MIMEText(body, 'plain'))
        
        server = smtplib.SMTP_SSL(config.get('host', 'smtp.gmail.com'), int(config.get('port', 465)))
        server.login(config.get('user'), config.get('pass'))
        server.send_message(msg)
        server.quit()
        
        return True
        
    except Exception as e:
        print(f"ERROR: {e}")
        sys.exit(1)

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: email_cli.py <command> [args]")
        print("Commands:")
        print("  check [limit]  - Check inbox emails")
        print("  send <to> <subject> <body> - Send email")
        sys.exit(1)
    
    cmd = sys.argv[1]
    
    if cmd == 'check':
        limit = int(sys.argv[2]) if len(sys.argv) > 2 else 5
        emails = check_inbox(limit)
        print(json.dumps(emails, indent=2))
    
    elif cmd == 'send':
        if len(sys.argv) < 5:
            print("Usage: email_cli.py send <to> <subject> <body>")
            sys.exit(1)
        to, subject, body = sys.argv[2], sys.argv[3], ' '.join(sys.argv[4:])
        send_email(to, subject, body)
        print("Email sent!")
    
    else:
        print(f"Unknown command: {cmd}")
        sys.exit(1)
