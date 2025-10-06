#!/bin/bash
# ================================================
# 🧠 TxBooster_INT Auto Tag & Release Script
# Version : 1.0
# Author  : Jxey
# License : MIT License
# ================================================

set -e

# --- Detect version from module.prop ---
VERSION=$(grep -E "^version=" module.prop | cut -d'=' -f2)
if [ -z "$VERSION" ]; then
  echo "❌ Tidak bisa menemukan versi di module.prop!"
  exit 1
fi

TAG="v$VERSION"
MESSAGE="TxBooster_INT $TAG — Hybrid AI Policy Release"

echo "🚀 Membuat tag Git baru: $TAG"
git add .
git commit -m "$MESSAGE" || true  # lanjut walau tidak ada perubahan baru
git tag -a "$TAG" -m "$MESSAGE"

echo "📤 Mengirim tag ke GitHub..."
git push origin "$TAG"

echo "✅ Tag $TAG berhasil dikirim ke repository!"
echo "   Kamu bisa cek di: https://github.com/rendevouz999/TxBooster/releases"
