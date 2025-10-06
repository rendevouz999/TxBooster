#!/bin/bash
# ============================================================
# 🚀 TxBooster_INT Auto Tag & Release Script (Hybrid + Upload + Publish)
# Version : 1.6.1 (Stable)
# Author  : Jxey + ChatGPT
# License : MIT License
# ============================================================

set -e

REPO_OWNER="rendevouz999"
REPO_NAME="TxBooster"
GITHUB_API="https://api.github.com"
GITHUB_UPLOAD="https://uploads.github.com"
TOKEN_FILE="$HOME/.github_token"

# 🧩 Auto-detect environment
if [[ "$OSTYPE" == "linux-android"* ]]; then
  PLATFORM="Termux"
  DEFAULT_PATH="$HOME/storage/shared/TxBooster/TxBooster"
elif [[ "$OSTYPE" == "msys"* || "$OSTYPE" == "cygwin"* ]]; then
  PLATFORM="Windows"
  DEFAULT_PATH="$(pwd)"
else
  PLATFORM="Linux/Other"
  DEFAULT_PATH="$(pwd)"
fi

echo "🧩 Detected platform: $PLATFORM"
echo "📁 Default project path: $DEFAULT_PATH"

# 🧩 Ensure token exists
if [ ! -f "$TOKEN_FILE" ]; then
  echo "❌ GitHub token belum diset."
  echo "👉 Jalankan: echo -n '<your_token_here>' > ~/.github_token"
  echo "Pastikan token punya scope: repo, workflow"
  exit 1
fi
TOKEN=$(cat "$TOKEN_FILE")

# 🧩 Move into project directory
if [ -d "$DEFAULT_PATH" ]; then
  cd "$DEFAULT_PATH"
else
  echo "⚠️  Folder project tidak ditemukan di:"
  echo "   $DEFAULT_PATH"
  exit 1
fi

# 🧩 Check required files
if [ ! -f "module.prop" ]; then
  echo "❌ File module.prop tidak ditemukan di $(pwd)"
  exit 1
fi

# 🧩 Check if git is installed
if ! command -v git &> /dev/null; then
  echo "❌ git belum terinstal."
  echo "👉 Jalankan: pkg install git -y (di Termux)"
  echo "   atau install Git di Windows jika belum ada."
  exit 1
fi

# 🧩 Get version and tag
VERSION=$(grep -E "^version=" module.prop | cut -d'=' -f2)
TAG="v$VERSION"
MESSAGE="TxBooster_INT $TAG — Hybrid AI Policy Release"

# 🧩 Git operations
git add .
git commit -m "$MESSAGE" || true

if git rev-parse "$TAG" >/dev/null 2>&1; then
  echo "⚠️  Tag $TAG sudah ada, menghapus dan membuat ulang..."
  git tag -d "$TAG"
  git push origin :refs/tags/"$TAG" || true
fi

git tag -a "$TAG" -m "$MESSAGE"
git push origin "$TAG"

echo "✅ Tag $TAG berhasil dikirim ke GitHub!"

# 🧩 Prepare release note
RELEASE_NOTE_FILE="docs/RELEASE_NOTE_${TAG}.md"
if [ ! -f "$RELEASE_NOTE_FILE" ]; then
  RELEASE_NOTE_FILE="docs/RELEASE_NOTE_v0.0.5.md"
fi

# 🧩 Create release (safe JSON encoding for Markdown)
if [ -f "$RELEASE_NOTE_FILE" ]; then
  echo "📄 Menggunakan release note: $RELEASE_NOTE_FILE"
  BODY_ESCAPED=$(sed 's/"/\\"/g' "$RELEASE_NOTE_FILE" | tr -d '\r' | awk '{printf "%s\\n", $0}' | sed ':a;N;$!ba;s/\n/\\n/g')
else
  echo "⚠️ File release note tidak ditemukan, menggunakan pesan default."
  BODY_ESCAPED="TxBooster_INT $TAG Auto Release"
fi

JSON_PAYLOAD=$(cat <<EOF
{
  "tag_name": "$TAG",
  "target_commitish": "main",
  "name": "$MESSAGE",
  "body": "$BODY_ESCAPED",
  "draft": false,
  "prerelease": false
}
EOF
)

curl -s -X POST \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "$JSON_PAYLOAD" \
  "$GITHUB_API/repos/$REPO_OWNER/$REPO_NAME/releases" \
  > release_response.json

RELEASE_URL=$(grep -o '"html_url": *"[^"]*' release_response.json | cut -d'"' -f4)
RELEASE_ID=$(grep -o '"id": *[0-9]*' release_response.json | head -1 | grep -o '[0-9]*')

if [ -n "$RELEASE_ID" ]; then
  echo "🎉 Release berhasil dibuat!"
  echo "🔗 $RELEASE_URL"

  ASSET_FILE="TxBooster_INT_${TAG}_HybridSync_Final.zip"
  if [ -f "$ASSET_FILE" ]; then
    echo "⬆️  Mengupload $ASSET_FILE ke release..."
    curl -s -X POST \
      -H "Authorization: Bearer $TOKEN" \
      -H "Content-Type: application/zip" \
      --data-binary @"$ASSET_FILE" \
      "$GITHUB_UPLOAD/repos/$REPO_OWNER/$REPO_NAME/releases/$RELEASE_ID/assets?name=$ASSET_FILE" \
      > upload_response.json

    DOWNLOAD_URL=$(grep -o '"browser_download_url": *"[^"]*' upload_response.json | cut -d'"' -f4)
    if [ -n "$DOWNLOAD_URL" ]; then
      echo "✅ Upload selesai!"
      echo "📦 File tersedia di:"
      echo "🔗 $DOWNLOAD_URL"
    else
      echo "⚠️  Upload gagal. Lihat upload_response.json untuk debug."
    fi
  else
    echo "⚠️  File $ASSET_FILE tidak ditemukan, skip upload."
  fi
else
  echo "⚠️  Gagal membuat release. Lihat release_response.json untuk debug."
fi
