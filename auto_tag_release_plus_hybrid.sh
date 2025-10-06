#!/bin/bash
# ============================================================
# 🚀 TxBooster_INT Auto Tag & Release Script (Hybrid)
# Version : 1.3
# Author  : Jxey + ChatGPT
# License : MIT License
# ============================================================

set -e

REPO_OWNER="rendevouz999"
REPO_NAME="TxBooster"
GITHUB_API="https://api.github.com"
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
  echo "👉 Jalankan: echo '<your_token_here>' > ~/.github_token"
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
  echo "Silakan sesuaikan path manual di baris DEFAULT_PATH"
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
  echo "👉 Jalankan: pkg install git -y  (di Termux)"
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
git tag -a "$TAG" -m "$MESSAGE"
git push origin "$TAG"

echo "✅ Tag $TAG berhasil dikirim ke GitHub!"

# 🧩 Prepare release note
RELEASE_NOTE_FILE="docs/RELEASE_NOTE_${TAG}.md"
if [ ! -f "$RELEASE_NOTE_FILE" ]; then
  RELEASE_NOTE_FILE="docs/RELEASE_NOTE_v0.0.5.md"
fi
BODY=$(jq -Rs . < "$RELEASE_NOTE_FILE")

# 🧩 Create draft release
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
