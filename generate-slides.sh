#!/usr/bin/env bash
# Scans assets/ for image files and generates slides.json
# Usage: ./generate-slides.sh

set -euo pipefail
cd "$(dirname "$0")"

echo "["
first=true
find assets -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.gif" -o -iname "*.webp" -o -iname "*.svg" \) \
  ! -name "404.png" ! -name ".gitkeep" \
  | sed 's|^assets/||' \
  | sort \
  | while read -r file; do
    if [ "$first" = true ]; then
      first=false
    else
      echo ","
    fi
    printf '  "%s"' "$file"
  done
echo ""
echo "]"
