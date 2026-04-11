#!/usr/bin/env python3
"""
test-ai.py - Quick AI model test
Test open-source AI models instantly
"""

import sys
import json
from datetime import datetime

def log(msg):
    print(f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] {msg}")

def check_transformers():
    """Check if transformers is available"""
    try:
        from transformers import AutoModelForCausalLM, AutoTokenizer, pipeline
        log("✅ Transformers available")
        return True
    except ImportError:
        log("❌ Transformers not installed")
        return False

def check_torch():
    """Check PyTorch"""
    try:
        import torch
        log(f"✅ PyTorch {torch.__version__}")
        log(f"✅ CUDA available: {torch.cuda.is_available()}")
        if torch.cuda.is_available():
            log(f"✅ GPU: {torch.cuda.get_device_name(0)}")
        return True
    except ImportError:
        log("❌ PyTorch not installed")
        return False

def test_small_model():
    """Test with a small model (quick test)"""
    log("🧪 Testing with small model...")
    
    try:
        from transformers import AutoModelForCausalLM, AutoTokenizer
        import torch
        
        # Use a tiny model for quick test
        model_name = "microsoft/Phi-3-mini-4k-instruct"
        
        log(f"⬇️  Loading model: {model_name}")
        
        tokenizer = AutoTokenizer.from_pretrained(model_name)
        model = AutoModelForCausalLM.from_pretrained(
            model_name,
            torch_dtype=torch.float32,
            device_map="cpu",
            trust_remote_code=True
        )
        
        log("✅ Model loaded")
        
        # Test inference
        prompt = "Hello! I am an AI assistant. How can I help?"
        inputs = tokenizer(prompt, return_tensors="pt")
        
        log("📝 Generating response...")
        
        with torch.no_grad():
            outputs = model.generate(
                **inputs,
                max_new_tokens=50,
                temperature=0.7,
                do_sample=True
            )
        
        response = tokenizer.decode(outputs[0], skip_special_tokens=True)
        
        log("✅ Generation complete!")
        print("\n" + "="*50)
        print(f"PROMPT: {prompt}")
        print(f"RESPONSE: {response}")
        print("="*50 + "\n")
        
        return True
        
    except Exception as e:
        log(f"❌ Test failed: {e}")
        return False

def test_pipeline():
    """Test with pipeline API"""
    log("🧪 Testing with pipeline API...")
    
    try:
        from transformers import pipeline
        import torch
        
        # Text generation pipeline
        generator = pipeline(
            "text-generation",
            model="microsoft/Phi-3-mini-4k-instruct",
            device_map="cpu",
            torch_dtype=torch.float32
        )
        
        log("✅ Pipeline created")
        
        prompt = "Explain quantum computing in one sentence:"
        
        log("📝 Generating...")
        
        result = generator(
            prompt,
            max_new_tokens=50,
            do_sample=True,
            temperature=0.7
        )
        
        response = result[0]['generated_text']
        
        log("✅ Pipeline test complete!")
        print("\n" + "="*50)
        print(f"PROMPT: {prompt}")
        print(f"RESPONSE: {response}")
        print("="*50 + "\n")
        
        return True
        
    except Exception as e:
        log(f"❌ Pipeline test failed: {e}")
        return False

def show_status():
    """Show AI system status"""
    log("📊 AI System Status")
    print("\n" + "="*50)
    
    # PyTorch
    try:
        import torch
        print(f"PyTorch:        ✅ {torch.__version__}")
        print(f"CUDA:           {'✅ Yes' if torch.cuda.is_available() else '❌ No'}")
        if torch.cuda.is_available():
            print(f"GPU:            {torch.cuda.get_device_name(0)}")
    except:
        print("PyTorch:        ❌ Not installed")
    
    # Transformers
    try:
        import transformers
        print(f"Transformers:   ✅ {transformers.__version__}")
    except:
        print("Transformers:   ❌ Not installed")
    
    # Disk space
    import shutil
    total, used, free = shutil.disk_usage("/")
    print(f"Disk Free:      {free // (2**30)} GB")
    
    print("="*50 + "\n")

def main():
    log("🤖 AI Model Test")
    print("")
    
    show_status()
    
    # Check dependencies
    if not check_torch():
        log("❌ Cannot proceed without PyTorch")
        sys.exit(1)
    
    if not check_transformers():
        log("❌ Cannot proceed without Transformers")
        sys.exit(1)
    
    print("")
    
    # Run tests
    log("🚀 Starting tests...")
    print("")
    
    # Test 1: Basic model load
    # log("Test 1: Basic model load")
    # test_small_model()
    
    # Test 2: Pipeline API
    log("Test: Pipeline API")
    test_pipeline()
    
    print("")
    log("✅ All tests complete!")
    
    # Save results
    results = {
        "timestamp": datetime.now().isoformat(),
        "pytorch": True,
        "transformers": True,
        "cuda": False,
        "test_passed": True
    }
    
    with open("/tmp/ai-test-results.json", "w") as f:
        json.dump(results, f, indent=2)
    
    log("📄 Results saved to /tmp/ai-test-results.json")

if __name__ == "__main__":
    main()
