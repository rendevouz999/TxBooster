#!/bin/bash
# ============================================================
# 🚀 TxBooster_INT Auto Tag & Release Script (Hybrid + Upload + Publish)
# Version : 1.7a (Windows Safe JSON Fix)
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

# 🧩 Check token
if [ ! -f "$TOKEN_FILE" ]; then
  echo "❌ GitHub token belum diset."
  echo "👉 Jalankan: echo -n '<your_token_here>' > ~/.github_token"
  exit 1
fi
TOKEN=$(cat "$TOKEN_FILE")

# 🧩 Move into project directory
if [ -d "$DEFAULT_PATH" ]; then
  cd "$DEFAULT_PATH"
else
  echo "⚠️  Folder project tidak ditemukan di: $DEFAULT_PATH"
  exit 1
fi

# 🧩 Check module.prop
if [ ! -f "module.prop" ]; then
  echo "❌ File module.prop tidak ditemukan."
  exit 1
fi

# 🧩 Ensure git exists
if ! command -v git &>/dev/null; then
  echo "❌ Git belum terinstal."
  exit 1
fi

# 🧩 Get version & tag
VERSION=$(grep -E "^version=" module.prop | cut -d'=' -f2)
TAG="v$VERSION"
MESSAGE="TxBooster_INT $TAG — Hybrid AI Policy Release"

# 🧩 Git tag process
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
echo "📄 Menggunakan release note: $RELEASE_NOTE_FILE"

# 🧩 Safe temp file creation (works on Windows + Linux)
if [ -d "/tmp" ]; then
  TMP_JSON=$(mktemp)
else
  TMP_JSON="$TEMP/tmp_payload_$$.json"
fi

# 🧩 Choose python executable automatically
PYTHON=$(command -v python3 || command -v python)
if [ -z "$PYTHON" ]; then
  echo "❌ Python tidak ditemukan di PATH."
  exit 1
fi

# 🧩 Create JSON payload safely using Python
$PYTHON - <<PY
import json, sys, pathlib
body = pathlib.Path("$RELEASE_NOTE_FILE").read_text(encoding="utf-8")
payload = {
  "tag_name": "$TAG",
  "target_commitish": "main",
  "name": "$MESSAGE",
  "body": body,
  "draft": False,
  "prerelease": False
}
pathlib.Path(r"$TMP_JSON").write_text(json.dumps(payload, ensure_ascii=False), encoding="utf-8")
print(f"✅ Payload JSON saved: {pathlib.Path(r'$TMP_JSON')}")
PY

# 🧩 Send to GitHub API
HTTP_CODE=$(curl -s -o release_response.json -w '%{http_code}' \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  --data-binary @"$TMP_JSON" \
  "$GITHUB_API/repos/$REPO_OWNER/$REPO_NAME/releases")

if [ "$HTTP_CODE" -ne 201 ]; then
  echo "❌ Gagal membuat release (HTTP $HTTP_CODE)"
  cat release_response.json
  exit 1
fi

RELEASE_URL=$(grep -o '"html_url": *"[^"]*' release_response.json | cut -d'"' -f4)
RELEASE_ID=$(grep -o '"id": *[0-9]*' release_response.json | head -1 | grep -o '[0-9]*')
echo "🎉 Release berhasil dibuat!"
echo "🔗 $RELEASE_URL"

# 🧩 Upload asset
ASSET_FILE="TxBooster_INT_${TAG}_HybridSync_Final.zip"
if [ -f "$ASSET_FILE" ]; then
  echo "⬆️  Mengupload asset: $ASSET_FILE"
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
    echo "⚠️ Upload gagal. Lihat upload_response.json"
  fi
else
  echo "⚠️ File $ASSET_FILE tidak ditemukan, skip upload."
fi
