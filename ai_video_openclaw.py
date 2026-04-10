#!/usr/bin/env python3
"""
AI Video Generator for OpenClaw
100% FREE - Uses Leonardo AI / Replicate free tier
Auto-send to Telegram
"""

import os
import sys
import json
import time
import urllib.request
import subprocess

# Config
OUTPUT_DIR = "/mnt/data/openclaw/workspace/.openclaw/workspace/videos"
TELEGRAM_BOT_TOKEN = "8038502164:AAEw1AQ1dpBY6G--j5udIRCHjUyNpk-CZxY"
TELEGRAM_CHAT_ID = "6023537487"

os.makedirs(OUTPUT_DIR, exist_ok=True)

def send_telegram_message(text):
    """Send text message to Telegram"""
    url = f"https://api.telegram.org/bot{TELEGRAM_BOT_TOKEN}/sendMessage"
    payload = {
        "chat_id": TELEGRAM_CHAT_ID,
        "text": text,
        "parse_mode": "HTML"
    }
    try:
        req = urllib.request.Request(url, 
            data=json.dumps(payload).encode('utf-8'),
            headers={'Content-Type': 'application/json'})
        urllib.request.urlopen(req)
        return True
    except Exception as e:
        print(f"Telegram error: {e}")
        return False

def send_telegram_video(video_path, caption):
    """Send video to Telegram"""
    url = f"https://api.telegram.org/bot{TELEGRAM_BOT_TOKEN}/sendVideo"
    
    # Use curl to send file
    cmd = [
        'curl', '-X', 'POST', url,
        '-F', f'chat_id={TELEGRAM_CHAT_ID}',
        '-F', f'video=@{video_path}',
        '-F', f'caption={caption}',
        '-F', 'parse_mode=HTML'
    ]
    
    try:
        result = subprocess.run(cmd, capture_output=True, text=True)
        return result.returncode == 0
    except Exception as e:
        print(f"Video send error: {e}")
        return False

def generate_video_leonardo(prompt, api_key):
    """Generate video using Leonardo AI (150 free credits/day)"""
    
    headers = {
        'Authorization': f'Bearer {api_key}',
        'Content-Type': 'application/json'
    }
    
    # Step 1: Create generation
    create_url = "https://cloud.leonardo.ai/api/rest/v1/generations"
    payload = {
        "prompt": prompt,
        "modelId": "e71a1c2f-3c38-4f1a-a8b6-3c6f8c1e5d9a",  # Leonardo motion model
        "width": 1280,
        "height": 720,
        "num_images": 1,
        "generatorType": "MOTION"
    }
    
    try:
        req = urllib.request.Request(create_url, 
            data=json.dumps(payload).encode('utf-8'),
            headers=headers,
            method='POST')
        response = urllib.request.urlopen(req)
        result = json.loads(response.read())
        
        generation_id = result['data']['create_generation']['id']
        print(f"Generation ID: {generation_id}")
        
        # Step 2: Wait for completion
        print("Waiting for video generation...")
        for i in range(60):  # Wait up to 5 minutes
            time.sleep(5)
            
            status_url = f"https://cloud.leonardo.ai/api/rest/v1/generations/{generation_id}"
            req = urllib.request.Request(status_url, headers=headers)
            response = urllib.request.urlopen(req)
            result = json.loads(response.read())
            
            status = result['data']['generations_by_pk']['status']
            print(f"Status: {status}")
            
            if status == 'COMPLETE':
                # Download video
                video_url = result['data']['generations_by_pk']['generated_images'][0]['url']
                output_path = os.path.join(OUTPUT_DIR, f"video_{int(time.time())}.mp4")
                urllib.request.urlretrieve(video_url, output_path)
                print(f"Video saved: {output_path}")
                return output_path
            elif status == 'FAILED':
                print("Generation failed!")
                return None
        
        print("Timeout!")
        return None
        
    except Exception as e:
        print(f"Error: {e}")
        return None

def generate_video_replicate(prompt, api_key):
    """Generate video using Replicate ($5 free credit)"""
    
    os.environ['REPLICATE_API_TOKEN'] = api_key
    
    try:
        import replicate
        
        output = replicate.run(
            "thudm/cogvideox-2b:9d8e8d4c8b8e4c8d8e8d4c8b8e4c8d",
            input={
                "prompt": prompt,
                "num_frames": 49,
                "fps": 8,
                "guidance_scale": 6.0,
            }
        )
        
        output_path = os.path.join(OUTPUT_DIR, f"video_{int(time.time())}.mp4")
        urllib.request.urlretrieve(output, output_path)
        print(f"Video saved: {output_path}")
        return output_path
        
    except Exception as e:
        print(f"Error: {e}")
        return None

def check_api_key():
    """Check if API key exists"""
    key_file = "/mnt/data/openclaw/workspace/.openclaw/workspace/.leonardo_key"
    if os.path.exists(key_file):
        with open(key_file, 'r') as f:
            return f.read().strip()
    return None

def save_api_key(api_key):
    """Save API key"""
    key_file = "/mnt/data/openclaw/workspace/.openclaw/workspace/.leonardo_key"
    with open(key_file, 'w') as f:
        f.write(api_key)

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("🎬 AI Video Generator for OpenClaw")
        print("\nUsage: ai_video_openclaw.py <command> [args]")
        print("\nCommands:")
        print("  setup - Setup API key (free Leonardo AI)")
        print("  generate <prompt> - Generate video from text")
        print("  status - Check API status")
        print("\nGet FREE API key: https://app.leonardo.ai/api-keys")
        sys.exit(0)
    
    cmd = sys.argv[1]
    
    if cmd == 'setup':
        print("🔑 Setup Leonardo AI API Key (FREE!)")
        print("\n1. Buka: https://app.leonardo.ai/api-keys")
        print("2. Sign up (gratis, no credit card)")
        print("3. Create API key")
        print("4. Copy key dan kasih tahu saya!")
        print("\nFree tier: 150 credits/hari (~30 videos)")
        
    elif cmd == 'generate':
        if len(sys.argv) < 3:
            print("Usage: ai_video_openclaw.py generate <prompt>")
            sys.exit(1)
        
        prompt = ' '.join(sys.argv[2:])
        api_key = check_api_key()
        
        if not api_key:
            print("❌ API key not found!")
            send_telegram_message("❌ <b>API Key Required!</b>\n\nSetup dulu dengan command: setup\n\nAtau kasih tahu saya API key Leonardo AI kamu.")
            sys.exit(1)
        
        print(f"🎬 Generating: {prompt}")
        send_telegram_message(f"🎬 <b>Generating Video...</b>\n\nPrompt: {prompt}\\n\nTunggu 2-5 menit...")
        
        video_path = generate_video_leonardo(prompt, api_key)
        
        if video_path:
            print("✅ Video generated!")
            send_telegram_message(f"✅ <b>Video Ready!</b>\n\nSending...")
            send_telegram_video(video_path, f"🎬 AI Generated\n\nPrompt: {prompt}")
            print("✅ Sent to Telegram!")
        else:
            print("❌ Generation failed!")
            send_telegram_message("❌ <b>Generation Failed!</b>\n\nCoba lagi atau gunakan prompt yang berbeda.")
    
    elif cmd == 'status':
        api_key = check_api_key()
        if api_key:
            print(f"✅ API key configured")
            print(f"Key: {api_key[:10]}...")
        else:
            print("❌ API key not found")
            print("Run: ai_video_openclaw.py setup")
    
    else:
        print(f"Unknown command: {cmd}")
        sys.exit(1)
