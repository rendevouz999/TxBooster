#!/bin/bash
# ================================================
# 🚀 TxBooster_INT Auto Tag & Release Script (Plus)
# Version : 1.2
# Author  : Jxey
# License : MIT License
# ================================================

set -e

# --- Konfigurasi Utama ---
REPO_OWNER="rendevouz999"
REPO_NAME="TxBooster"
GITHUB_API="https://api.github.com"
GITHUB_UPLOAD="https://uploads.github.com"
TOKEN_FILE="$HOME/.github_token"   # tempat menyimpan token aman

# --- Cek token ---
if [ ! -f "$TOKEN_FILE" ]; then
  echo "❌ Token GitHub belum diset."
  echo "👉 Jalankan: echo '<your_token_here>' > ~/.github_token"
  echo "Pastikan token punya scope: repo, workflow"
  exit 1
fi

TOKEN=$(cat "$TOKEN_FILE")

# --- Ambil versi dari module.prop ---
VERSION=$(grep -E "^version=" module.prop | cut -d'=' -f2)
TAG="v$VERSION"
MESSAGE="TxBooster_INT $TAG — Hybrid AI Policy Release"

# --- Push tag ---
git add .
git commit -m "$MESSAGE" || true
git tag -a "$TAG" -m "$MESSAGE"
git push origin "$TAG"

echo "✅ Tag $TAG berhasil dikirim ke GitHub!"

# --- Cek file release note ---
RELEASE_NOTE_FILE="docs/RELEASE_NOTE_${TAG}.md"
if [ ! -f "$RELEASE_NOTE_FILE" ]; then
  echo "⚠️  File release note tidak ditemukan di $RELEASE_NOTE_FILE"
  echo "   Menggunakan fallback: docs/RELEASE_NOTE_v0.0.5.md"
  RELEASE_NOTE_FILE="docs/RELEASE_NOTE_v0.0.5.md"
fi

BODY=$(jq -Rs . < "$RELEASE_NOTE_FILE")

# --- Buat draft release di GitHub ---
echo "🌐 Membuat draft release $TAG di GitHub..."

curl -s -X POST \
  -H "Authorization: token $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"tag_name\": \"$TAG\",
    \"target_commitish\": \"main\",
    \"name\": \"$MESSAGE\",
    \"body\": $BODY,
    \"draft\": true,
    \"prerelease\": false
  }" \
  "$GITHUB_API/repos/$REPO_OWNER/$REPO_NAME/releases" \
  > release_response.json

RELEASE_URL=$(jq -r '.html_url' release_response.json 2>/dev/null)

if [ "$RELEASE_URL" != "null" ]; then
  echo "🎉 Draft release berhasil dibuat!"
  echo "🔗 $RELEASE_URL"
else
  echo "⚠️  Gagal membuat draft release. Lihat release_response.json untuk debug."
fi
