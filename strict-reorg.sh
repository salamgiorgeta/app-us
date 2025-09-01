#!/usr/bin/env bash
set -euo pipefail

# ─ Config (nu schimbă structura; doar creează ce lipsește)
CLEAN_GENERATED="${CLEAN_GENERATED:-0}"  # 0 = NU curăță .next/node_modules (safe)
VERBOSE="${VERBOSE:-1}"

say(){ echo -e "➤ $*"; }
exists(){ [ -e "$1" ]; }
ensure_dir(){ mkdir -p "$1"; git add -A "$1" >/dev/null 2>&1 || true; [ "$VERBOSE" = "1" ] && say "dir ok: $1"; }
ensure_file(){
  local p="$1"; shift || true
  if ! exists "$p"; then
    mkdir -p "$(dirname "$p")"
    if [ "$#" -gt 0 ]; then printf "%s\n" "$*" > "$p"; else touch "$p"; fi
    git add "$p" >/dev/null 2>&1 || true
    [ "$VERBOSE" = "1" ] && say "file created: $p"
  else
    [ "$VERBOSE" = "1" ] && say "file ok: $p"
  fi
}

# ─ Safety
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "✗ Nu e repo Git aici."; exit 1; }

say "Enforce structura pro-ready (fără mutări/redenumeri)…"

# ─ 1) DIRECTOARE — exact ca în structura ta
ensure_dir ".github/workflows"
ensure_dir "runbooks"
ensure_dir "scripts"
ensure_dir "terraform/datadog"
ensure_dir "src/app/(marketing)"
ensure_dir "src/app/(admin)"
ensure_dir "src/app/api/checkout/session"
ensure_dir "src/app/api/webhooks/verifone"
ensure_dir "src/app/api/health"
ensure_dir "src/app/api/cron"
ensure_dir "src/app/api/email/test-send"
ensure_dir "src/components"
ensure_dir "src/config"
ensure_dir "src/lib"
ensure_dir "src/lib/payments"
ensure_dir "src/content"
ensure_dir "src/styles"
ensure_dir "src/types"
ensure_dir "public"
ensure_dir ".husky"

# ─ 2) FIȘIERE — create DOAR dacă lipsesc (placeholdere minime)
# .github/workflows
ensure_file ".github/workflows/ci-e2e.yml"        "# ci-e2e placeholder"
ensure_file ".github/workflows/nightly-e2e.yml"   "# nightly-e2e placeholder"

# runbooks
ensure_file "runbooks/RB-001-latency-high.md"         "# Runbook: Latency High"
ensure_file "runbooks/RB-002-error-rate.md"           "# Runbook: Error Rate"
ensure_file "runbooks/RB-003-cron-failed-or-idle.md"  "# Runbook: Cron Failed/Idle"
ensure_file "runbooks/_TEMPLATE-incident.md"          "# Incident Template"

# scripts
ensure_file "scripts/seed-demo.ts" "// seed demo data"

# terraform/datadog
ensure_file "terraform/datadog/provider.tf"      "// terraform provider"
ensure_file "terraform/datadog/variables.tf"     "// terraform variables"
ensure_file "terraform/datadog/monitors_core.tf" "// terraform monitors core"
ensure_file "terraform/datadog/slo.tf"           "// terraform slo"
ensure_file "terraform/datadog/outputs.tf"       "// terraform outputs"

# src/app (Next)
ensure_file "src/app/layout.tsx"      "export default function RootLayout({children}:{children:React.ReactNode}){return (<html lang=\"en\"><body>{children}</body></html>)}"
ensure_file "src/app/globals.css"     "@import \"tailwindcss\";"
ensure_file "src/app/sitemap.ts"      "export default function sitemap(){return[]}"
ensure_file "src/app/robots.txt/route.ts" "export function GET(){return new Response(\"User-agent: *\\nAllow: /\\n\")}"

# api routes
ensure_file "src/app/api/checkout/session/route.ts" "// POST create checkout session (placeholder)"
ensure_file "src/app/api/webhooks/verifone/route.ts" "// POST verifone webhook (placeholder)"
ensure_file "src/app/api/health/route.ts"            "export const runtime='edge'; export async function GET(){return Response.json({ok:true})}"
ensure_file "src/app/api/cron/digest/route.ts"       "export async function GET(){return Response.json({ok:true,job:'digest'})}"
ensure_file "src/app/api/cron/reconcile/route.ts"    "export async function GET(){return Response.json({ok:true,job:'reconcile'})}"
ensure_file "src/app/api/cron/queue/route.ts"        "export async function GET(){return Response.json({ok:true,job:'queue'})}"
ensure_file "src/app/api/email/test-send/route.ts"   "export async function POST(){return Response.json({ok:true,sent:true})}"

# components/config/lib
ensure_file "src/components/Turnstile.tsx" "export default function Turnstile(){return null}"
ensure_file "src/config/pricing.verifone.ts" "export const PRICING = {};"

ensure_file "src/lib/csp.ts"        "export const csp='';"
ensure_file "src/lib/logger.ts"     "export const logger={info:console.log,warn:console.warn,error:console.error,debug:console.debug};"
ensure_file "src/lib/dd-rum.ts"     "export const ddRum={};"
ensure_file "src/lib/payments/verifone.ts" "export const verifone={};"
ensure_file "src/lib/rate-limit.ts" "export const rateLimit=()=>true;"
ensure_file "src/lib/supabase.ts"   "export const supabase={};"
ensure_file "src/lib/stripe.ts"     "export const stripe={};"
ensure_file "src/lib/resend.ts"     "export const resend={};"
ensure_file "src/lib/z.ts"          "export const z={};"

# root files
ensure_file ".eslintrc.js"          "module.exports={root:true};"
ensure_file ".prettierrc"           "{}"
ensure_file "commitlint.config.js"  "module.exports={extends:['@commitlint/config-conventional']};"
ensure_file "next.config.mjs"       "export default {reactStrictMode:true,experimental:{}};"
ensure_file "package.json"          "{\"name\":\"app-us\",\"private\":true}"
ensure_file ".node-version"         "20"
ensure_file "vercel.json"           "{\"cleanUrls\":true}"
ensure_file "README.md"             "# app-us"

# ─ 3) Curățenie opțională (artefacte generate) — executată doar dacă CLEAN_GENERATED=1
if [ "$CLEAN_GENERATED" = "1" ]; then
  say "Curăț artefacte generate…"
  git rm -r --cached --ignore-unmatch node_modules .next .turbo .vercel dist coverage .parcel-cache .cache 2>/dev/null || true
  rm -rf node_modules .next .turbo .vercel dist coverage .parcel-cache .cache 2>/dev/null || true
  find . -name ".DS_Store" -delete 2>/dev/null || true
  find . -maxdepth 3 -type f -name "*.log" -delete 2>/dev/null || true
fi

# ─ 4) Commit
git add -A
if git diff --cached --quiet; then
  say "Nimic nou de comis — structura era deja conformă."
else
  git commit -m "chore(structure): enforce pro-ready layout (ensure-missing only)"
  say "Commit creat."
fi

say "Done."
