#!/usr/bin/env python3
"""
AI Video Generator via Replicate API
No GPU needed - uses cloud GPU!
"""

import replicate
import os
import time

OUTPUT_DIR = "/mnt/data/openclaw/workspace/.openclaw/workspace/videos"
os.makedirs(OUTPUT_DIR, exist_ok=True)

# API Key from environment or config
REPLICATE_API_TOKEN = os.environ.get("REPLICATE_API_TOKEN", "")

def generate_video_cogvideo(prompt, duration=6, aspect_ratio="16:9", output_name=None):
    """Generate video using CogVideoX via Replicate"""
    
    if not REPLICATE_API_TOKEN:
        return {"error": "REPLICATE_API_TOKEN not set"}
    
    print(f"🎬 Generating video: {prompt}")
    print(f"Duration: {duration}s, Aspect Ratio: {aspect_ratio}")
    
    try:
        output = replicate.run(
            "thudm/cogvideox-2b:9d8e8d4c8b8e4c8d8e8d4c8b8e4c8d",
            input={
                "prompt": prompt,
                "num_frames": 49,
                "fps": 8,
                "guidance_scale": 6.0,
                "num_inference_steps": 50,
            }
        )
        
        if output_name is None:
            output_name = f"video_{int(time.time())}.mp4"
        
        output_path = os.path.join(OUTPUT_DIR, output_name)
        
        # Download video
        import urllib.request
        urllib.request.urlretrieve(output, output_path)
        
        print(f"✅ Video saved: {output_path}")
        return {"success": True, "path": output_path, "url": output}
        
    except Exception as e:
        print(f"❌ Error: {e}")
        return {"error": str(e)}

def generate_video_svd(image_path, motion_bucket=127, fps=7, output_name=None):
    """Generate video from image using SVD via Replicate"""
    
    if not REPLICATE_API_TOKEN:
        return {"error": "REPLICATE_API_TOKEN not set"}
    
    print(f"🎬 Animating image: {image_path}")
    
    try:
        output = replicate.run(
            "stability-ai/stable-video-diffusion:3f0457e4619daac51203dedb49ac5058bd8c0d1d",
            input={
                "input_image": open(image_path, "rb"),
                "video_length": "14_frames_with_svd_xt",
                "frames_per_second": fps,
                "motion_bucket_id": motion_bucket,
            }
        )
        
        if output_name is None:
            output_name = f"video_{int(time.time())}.mp4"
        
        output_path = os.path.join(OUTPUT_DIR, output_name)
        
        import urllib.request
        urllib.request.urlretrieve(output, output_path)
        
        print(f"✅ Video saved: {output_path}")
        return {"success": True, "path": output_path, "url": output}
        
    except Exception as e:
        print(f"❌ Error: {e}")
        return {"error": str(e)}

def get_api_status():
    """Check API key status"""
    if REPLICATE_API_TOKEN:
        return {"status": "configured", "message": "API token found"}
    else:
        return {
            "status": "missing",
            "message": "Please set REPLICATE_API_TOKEN environment variable"
        }

if __name__ == '__main__':
    import sys
    
    if len(sys.argv) < 2:
        print("🎬 AI Video Generator (Replicate API)")
        print("\nUsage: ai_video_api.py <command> [args]")
        print("\nCommands:")
        print("  text <prompt> - Generate video from text (CogVideoX)")
        print("  image <path> - Generate video from image (SVD)")
        print("  status - Check API status")
        print("\nSetup:")
        print("  export REPLICATE_API_TOKEN='your_token_here'")
        print("\nGet API token: https://replicate.com/account/api-tokens")
        sys.exit(0)
    
    cmd = sys.argv[1]
    
    if cmd == 'text':
        prompt = ' '.join(sys.argv[2:])
        result = generate_video_cogvideo(prompt)
        print(result)
    
    elif cmd == 'image':
        if len(sys.argv) < 3:
            print("Usage: ai_video_api.py image <path>")
            sys.exit(1)
        result = generate_video_svd(sys.argv[2])
        print(result)
    
    elif cmd == 'status':
        status = get_api_status()
        print(f"Status: {status['status']}")
        print(f"Message: {status['message']}")
    
    else:
        print(f"Unknown command: {cmd}")
        sys.exit(1)
