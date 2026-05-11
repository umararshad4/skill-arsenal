#!/usr/bin/env bash
# ui-arsenal verify — run quality gates and print numbers
# Usage: bash verify.sh [URL]
#   URL defaults to http://localhost:3000
#
# Requires: node, npx, curl. Optional: jq (richer output), Chrome (for Lighthouse + axe).
# Run from the project root.

URL="${1:-http://localhost:3000}"
TMPDIR="${TMPDIR:-/tmp}"
LH_OUT="$TMPDIR/ui-arsenal-lh.json"

section() { printf '\n=== %s ===\n' "$1"; }
has() { command -v "$1" >/dev/null 2>&1; }

section "Environment"
echo "URL:  $URL"
echo "CWD:  $(pwd)"
has node && echo "node: $(node --version)" || echo "node: MISSING"
has npx  && echo "npx:  $(npx --version 2>/dev/null || echo unknown)" || echo "npx:  MISSING"
has jq   && echo "jq:   $(jq --version)"   || echo "jq:   missing (Lighthouse output won't parse cleanly)"
has curl && echo "curl: ok" || { echo "curl: MISSING — cannot continue"; exit 1; }

section "Build (npm run build)"
if [ -f package.json ] && grep -q '"build"' package.json; then
  echo "Running… this can take 30–90s"
  if npm run build 2>&1 | tee "$TMPDIR/ui-arsenal-build.log" | tail -100; then
    echo
    echo "Build log: $TMPDIR/ui-arsenal-build.log"
    echo "Look for 'First Load JS' per route — flag any > 200KB."
  else
    echo "Build failed. Check $TMPDIR/ui-arsenal-build.log"
  fi
else
  echo "skip — no build script (run from project root with package.json)"
fi

section "URL reachability"
if curl -fsS --max-time 5 "$URL" -o /dev/null; then
  echo "OK — $URL responds"
else
  echo "NOT REACHABLE — start dev server (npm run dev) before continuing"
  echo "Skipping Lighthouse + axe."
  exit 0
fi

section "Lighthouse (performance + accessibility)"
if has npx; then
  echo "Running… ~30s"
  npx --yes lighthouse "$URL" \
    --only-categories=performance,accessibility,best-practices \
    --output=json --output-path="$LH_OUT" \
    --chrome-flags="--headless=new --no-sandbox" \
    --quiet 2>/dev/null || true

  if [ -f "$LH_OUT" ] && has jq; then
    PERF=$(jq -r '(.categories.performance.score * 100) | floor // "?"' "$LH_OUT")
    A11Y=$(jq -r '(.categories.accessibility.score * 100) | floor // "?"' "$LH_OUT")
    BP=$(jq -r   '(.categories["best-practices"].score * 100) | floor // "?"' "$LH_OUT")
    LCP=$(jq -r  '.audits["largest-contentful-paint"].displayValue // "?"' "$LH_OUT")
    CLS=$(jq -r  '.audits["cumulative-layout-shift"].displayValue // "?"' "$LH_OUT")
    TBT=$(jq -r  '.audits["total-blocking-time"].displayValue // "?"' "$LH_OUT")
    FCP=$(jq -r  '.audits["first-contentful-paint"].displayValue // "?"' "$LH_OUT")
    printf '%-22s %s   (target ≥ 90)\n'  "Performance:"    "$PERF / 100"
    printf '%-22s %s   (target ≥ 95)\n'  "Accessibility:"  "$A11Y / 100"
    printf '%-22s %s\n'                  "Best Practices:" "$BP / 100"
    printf '%-22s %s   (target ≤ 2.5s)\n' "LCP:"           "$LCP"
    printf '%-22s %s   (target ≤ 0.1)\n'  "CLS:"           "$CLS"
    printf '%-22s %s   (target ≤ 200ms)\n' "TBT:"          "$TBT"
    printf '%-22s %s\n'                   "FCP:"           "$FCP"
  elif [ -f "$LH_OUT" ]; then
    echo "Lighthouse ran but jq is missing — install jq to parse output."
    echo "Raw report: $LH_OUT"
  else
    echo "Lighthouse failed. Common causes:"
    echo "  - Chrome not installed (Lighthouse needs Chrome/Chromium)"
    echo "  - URL not reachable"
    echo "  - Network/firewall blocking npx download"
  fi
else
  echo "skip — npx unavailable"
fi

section "axe-core accessibility scan"
if has npx; then
  echo "Running… ~10s"
  AXE_OUT=$(npx --yes @axe-core/cli "$URL" --tags wcag2a,wcag2aa --exit 2>&1 || true)
  echo "$AXE_OUT" | grep -E "(Violations|critical|serious|moderate|minor|0 violations|passes|incomplete)" | head -30
  echo
  VIOLATIONS=$(echo "$AXE_OUT" | grep -Eo "[0-9]+ violations?" | head -1)
  echo "Summary: ${VIOLATIONS:-(could not parse — see full output above)}"
else
  echo "skip — npx unavailable"
fi

section "Thresholds (compare each metric above)"
cat <<'EOF'
Performance       ≥ 90
Accessibility     ≥ 95
LCP               ≤ 2.5s
CLS               ≤ 0.1
TBT               ≤ 200ms
First Load JS     ≤ 200 KB per route
axe violations    0

Any FAIL above is a blocker. Do not report "done" while any threshold is missed.
EOF

printf '\nFull Lighthouse report (JSON): %s\n' "$LH_OUT"
printf 'Build log: %s/ui-arsenal-build.log\n' "$TMPDIR"
