#!/usr/bin/env bash
set -euo pipefail

APP_NAME="${APP_NAME:-app-us}"
OUT_ZIP="${OUT_ZIP:-app-us-build.zip}"
ROOT_DIR="${ROOT_DIR:-.}"   # set to project root if running from elsewhere

echo "==> Using pnpm to build and package: $APP_NAME"

cd "$ROOT_DIR"

# 0) Sanity checks
if ! command -v pnpm >/dev/null 2>&1; then
  echo "ERROR: pnpm not found. Install pnpm first (corepack enable pnpm)." >&2
  exit 1
fi

if [ ! -f package.json ]; then
  echo "ERROR: package.json not found in $(pwd). Set ROOT_DIR correctly." >&2
  exit 1
fi

# 1) Clean & install deps (production friendly)
echo "==> Installing dependencies with pnpm"
pnpm install

# 2) Build (expects scripts.build in package.json)
echo "==> Building production bundle"
pnpm build

# 3) Prepare staging dir
STAGE_DIR=".server_release_stage"
rm -rf "$STAGE_DIR"
mkdir -p "$STAGE_DIR"

# 4) Copy required files
echo "==> Collecting build artifacts"
# Next.js build output
if [ -d ".next" ]; then
  cp -R .next "$STAGE_DIR/.next"
fi

# Public assets
if [ -d "public" ]; then
  cp -R public "$STAGE_DIR/public"
fi

# Configs & manifests
cp package.json "$STAGE_DIR/"
[ -f pnpm-lock.yaml ] && cp pnpm-lock.yaml "$STAGE_DIR/"
ls next.config.* >/dev/null 2>&1 && cp next.config.* "$STAGE_DIR/" || true

# Optional helpers, if present
[ -f README_RUN.md ] && cp README_RUN.md "$STAGE_DIR/"
[ -f Dockerfile ] && cp Dockerfile "$STAGE_DIR/"
[ -f .env.example ] && cp .env.example "$STAGE_DIR/"

# 5) Create ZIP
echo "==> Creating ZIP: $OUT_ZIP"
rm -f "$OUT_ZIP"
( cd "$STAGE_DIR" && zip -r "../$OUT_ZIP" . >/dev/null )

# 6) Done
echo "==> Done. Created $OUT_ZIP in $(pwd)"
echo "Attach this ZIP to your GitHub Release (Assets)."
