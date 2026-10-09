#!/usr/bin/env bash
# Assemble the Docker build context for OpenBB Lite from the upstream source
# snapshot (https://github.com/OpenBB-finance/workspace), as lite/build-local.sh
# does it: lite/ files + backend/ (from backend-api/backend) + terminalpro/.
# Usage: assemble-context.sh <upstream-checkout> <output-dir>
set -euo pipefail
SRC="$1"; OUT="$2"
rm -rf "$OUT"; mkdir -p "$OUT/backend" "$OUT/terminalpro"
cp -a "$SRC/lite/." "$OUT/"
tar -C "$SRC/backend-api/backend" --exclude=.git --exclude=__pycache__ -cf - . | tar -C "$OUT/backend" -xf -
tar -C "$SRC/terminalpro" --exclude=.git --exclude=node_modules --exclude=dist -cf - . | tar -C "$OUT/terminalpro" -xf -
# Upstream ships bun.lock only; the Dockerfile expects package-lock.json + npm ci.
sed -i \
  -e 's#COPY terminalpro/package.json terminalpro/package-lock.json ./#COPY terminalpro/package.json ./#' \
  -e 's#^RUN npm ci$#RUN npm install --legacy-peer-deps --no-audit --no-fund#' \
  "$OUT/Dockerfile"
grep -q 'npm install --legacy-peer-deps' "$OUT/Dockerfile"
