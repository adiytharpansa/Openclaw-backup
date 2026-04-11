# 🚀 Setup Cloud Backup - SUPER SIMPLE!

## Cara Setup (2 Langkah Aja!)

### Langkah 1: Dapatkan Credentials

**GitHub** (1 menit):
1. Buka: https://github.com/signup
2. Daftar (gratis, no credit card!)
3. Username lo: _______________ (isi ini)

**Telegram** (1 menit):
1. Buka: https://my.telegram.org/apps
2. Login dengan nomor HP
3. Create new application
4. API ID: _______________ (copy dari sana)
5. API Hash: _______________ (copy dari sana)
6. Nomor HP: _______________ (contoh: +628123456789)

**Google Drive** (opsional, 1 menit):
1. Punya akun Google? (Gmail)
2. Kalau ada, udah siap!

---

### Langkah 2: Isi File .env

Setelah lo dapet semua credentials di atas:

```bash
cd /mnt/data/openclaw/workspace/.openclaw/workspace
nano .env
```

Isi seperti ini:

```
# GitHub
GITHUB_USERNAME=Starboy4043
GITHUB_REPO=openclaw-backup

# Telegram
TELEGRAM_API_ID=12345678
TELEGRAM_API_HASH=abc123def456
TELEGRAM_PHONE=+628123456789

# Google Drive
GDRIVE_FOLDER=OpenClaw-Backup
```

Simpan (Ctrl+X, Y, Enter)

---

### Langkah 3: Jalankan!

```bash
./scripts/cloud-backup-auto.sh
```

**DONE!** ✅

Script akan:
- Setup GitHub repo otomatis
- Install Telegram library
- Upload backup ke semua cloud
- Kasih laporan lengkap

---

## Kalau Ada Masalah

**"nano" nggak ada?**
```bash
# Pakai editor lain
code .env
# atau
vi .env
```

**Script error?**
```bash
# Coba jalankan manual satu-satu:

# GitHub
git remote add origin https://github.com/Starboy4043/openclaw-backup.git
git push -u origin main

# Telegram
pip3 install telethon
python3 scripts/telegram-backup.py

# Google Drive
gog auth
bash scripts/gdrive-backup.sh
```

---

## Mau Lebih Mudah Lagi?

Kasih tau gue credentials lo (kalau percaya), gue setupin semua otomatis! 😄

Atau tanya aja kalau bingung - gue siap bantu step-by-step!

---

**Status:** ✅ Skill siap dipakai!
**Script:** `./scripts/cloud-backup-auto.sh`
**Config:** `.env` file
**Docs:** `skills/cloud-backup-automation/README.md`
