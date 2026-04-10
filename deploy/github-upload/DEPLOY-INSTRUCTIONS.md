# 🚀 Quick Deploy Instructions

## Step 1: Create GitHub Repository

1. Go to: https://github.com/new
2. Repository name: `openclaw`
3. Make it Public
4. Click "Create repository"

## Step 2: Upload Files

### Option A: Using Git (Recommended)

```bash
# Clone your new repo
git clone https://github.com/YOUR_USERNAME/openclaw.git
cd openclaw

# Copy all files from this folder
cp /path/to/github-upload/* .

# Commit and push
git add .
git commit -m "Deploy OpenClaw browser runtime"
git push origin main
```

### Option B: Using GitHub Web UI

1. In your GitHub repo, click "uploading an existing file"
2. Drag & drop all files from this folder
3. Click "Commit changes"

## Step 3: Enable GitHub Pages

1. Go to Settings → Pages
2. Source: "Deploy from a branch"
3. Branch: "main"
4. Folder: "/" (root)
5. Click "Save"

## Step 4: Done! 🎉

Wait 2-3 minutes, then access:
```
https://YOUR_USERNAME.github.io/openclaw/
```

Replace YOUR_USERNAME with your GitHub username!

## Troubleshooting

**Site not loading?**
- Wait 2-3 minutes for GitHub Pages to build
- Check Settings → Pages is enabled
- Verify files are in main branch

**404 Error?**
- Make sure index.html is in root folder
- Check GitHub Pages is enabled
- Try hard refresh (Ctrl+Shift+R)

---

**Need help?** Check README.md or open an issue!
