#!/usr/bin/env python3
"""
AI Video Generator - CogVideoX & Stable Video Diffusion
Generate high-quality videos from text or images
"""

import torch
from diffusers import CogVideoXPipeline, StableVideoDiffusionPipeline
from diffusers.utils import export_to_video
import os
import time

MODEL_DIR = "/mnt/data/openclaw/workspace/.local/share/ai-video-models"
OUTPUT_DIR = "/mnt/data/openclaw/workspace/.openclaw/workspace/videos"

os.makedirs(MODEL_DIR, exist_ok=True)
os.makedirs(OUTPUT_DIR, exist_ok=True)

def load_cogvideox():
    """Load CogVideoX model (best quality)"""
    print("Loading CogVideoX...")
    pipe = CogVideoXPipeline.from_pretrained(
        "THUDM/CogVideoX-2b",
        torch_dtype=torch.float16
    )
    pipe.enable_model_cpu_offload()
    pipe.enable_vae_slicing()
    return pipe

def load_svd():
    """Load Stable Video Diffusion (image-to-video)"""
    print("Loading SVD...")
    pipe = StableVideoDiffusionPipeline.from_pretrained(
        "stabilityai/stable-video-diffusion-img2vid-xt",
        torch_dtype=torch.float16,
        variant="fp16"
    )
    pipe.enable_model_cpu_offload()
    return pipe

def generate_video_cogvideox(prompt, num_frames=49, fps=8, output_name=None):
    """Generate video from text using CogVideoX"""
    print(f"Generating video for: {prompt}")
    
    pipe = load_cogvideox()
    
    video = pipe(
        prompt=prompt,
        num_videos_per_prompt=1,
        num_inference_steps=50,
        num_frames=num_frames,
        guidance_scale=6.0,
        generator=torch.Generator(device="cuda").manual_seed(42) if torch.cuda.is_available() else None
    ).frames[0]
    
    if output_name is None:
        output_name = f"video_{int(time.time())}.mp4"
    
    output_path = os.path.join(OUTPUT_DIR, output_name)
    export_to_video(video, output_path, fps=fps)
    
    print(f"✅ Video saved: {output_path}")
    return output_path

def generate_video_svd(image_path, motion_bucket_id=127, fps=7, output_name=None):
    """Generate video from image using SVD"""
    print(f"Generating video from: {image_path}")
    
    from PIL import Image
    pipe = load_svd()
    
    image = Image.open(image_path)
    image = image.resize((1024, 576))
    
    generator = torch.Generator(device="cuda").manual_seed(42) if torch.cuda.is_available() else None
    
    frames = pipe(image, motion_bucket_id=motion_bucket_id, generator=generator).frames[0]
    
    if output_name is None:
        output_name = f"video_{int(time.time())}.mp4"
    
    output_path = os.path.join(OUTPUT_DIR, output_name)
    export_to_video(frames, output_path, fps=fps)
    
    print(f"✅ Video saved: {output_path}")
    return output_path

if __name__ == '__main__':
    import sys
    
    if len(sys.argv) < 2:
        print("Usage: ai_video.py <command> [args]")
        print("Commands:")
        print("  text <prompt> - Generate video from text (CogVideoX)")
        print("  image <path> - Generate video from image (SVD)")
        print("  models - List available models")
        sys.exit(1)
    
    cmd = sys.argv[1]
    
    if cmd == 'text':
        prompt = ' '.join(sys.argv[2:])
        generate_video_cogvideox(prompt)
    
    elif cmd == 'image':
        if len(sys.argv) < 3:
            print("Usage: ai_video.py image <path>")
            sys.exit(1)
        generate_video_svd(sys.argv[2])
    
    elif cmd == 'models':
        print(f"Model directory: {MODEL_DIR}")
        print(f"Output directory: {OUTPUT_DIR}")
        import subprocess
        result = subprocess.run(["ls", "-lh", MODEL_DIR], capture_output=True, text=True)
        print(result.stdout if result.stdout else "No models downloaded yet")
    
    else:
        print(f"Unknown command: {cmd}")
        sys.exit(1)
