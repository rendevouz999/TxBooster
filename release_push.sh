#!/bin/bash
# ======================================
# TxBooster_INT Auto Release Script
# Author: rendevouz999
# ======================================

VERSION=$1
BRANCH="release/${VERSION}"
REPO_URL="https://github.com/rendevouz999/TxBooster.git"

if [ -z "$VERSION" ]; then
  echo "❌ Gunakan format: ./release_push.sh v0.0.3"
  exit 1
fi

echo "🚀 Menyiapkan rilis TxBooster_INT ${VERSION}..."

# Pastikan di direktori out
cd "$(dirname "$0")"

# Inisialisasi git jika belum
if [ ! -d ".git" ]; then
  git init
  git remote add origin $REPO_URL
fi

# Cek apakah branch sudah ada
if git show-ref --verify --quiet refs/heads/$BRANCH; then
  git checkout $BRANCH
else
  git checkout -b $BRANCH
fi

# Tambah & commit semua file
git add .
git commit -m "Release build TxBooster_INT_${VERSION}"

# Push ke GitHub
git push -u origin $BRANCH --force

echo "✅ Rilis berhasil!"
echo "🔗 Lihat di: https://github.com/rendevouz999/TxBooster/tree/${BRANCH}"
