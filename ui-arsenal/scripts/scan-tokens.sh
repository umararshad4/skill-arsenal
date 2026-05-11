#!/usr/bin/env bash
# ui-arsenal scan-tokens — discover the project's design token vocabulary
# Usage: bash scan-tokens.sh [PROJECT_ROOT]
#   PROJECT_ROOT defaults to the current directory.
#
# Outputs a markdown report listing CSS variables, Tailwind config, shadcn
# config, fonts in use, and theme provider setup. Read this before
# fetching/adapting any component — never hardcode values that exist as tokens.

ROOT="${1:-.}"
cd "$ROOT" 2>/dev/null || { echo "Can't cd to $ROOT"; exit 1; }

has() { command -v "$1" >/dev/null 2>&1; }

cat <<EOF
# Project Design Tokens

Scanned: $(pwd)
Date:    $(date)

---

## CSS variables (theme tokens)

EOF

FOUND_CSS=0
for css in app/globals.css src/app/globals.css styles/globals.css src/styles/globals.css app/styles/globals.css; do
  if [ -f "$css" ]; then
    FOUND_CSS=1
    echo "### \`$css\`"
    echo
    echo '```css'
    # Grab CSS custom properties — anything starting with --
    grep -E "^\s*--[a-zA-Z]" "$css" | head -100
    echo '```'
    echo
  fi
done
[ "$FOUND_CSS" = "0" ] && echo "_(no globals.css found in standard locations — check styles/globals.css or app/globals.css)_"
echo

echo "---"
echo
echo "## Tailwind config"
echo
FOUND_TW=0
for cfg in tailwind.config.ts tailwind.config.js tailwind.config.mjs tailwind.config.cjs; do
  if [ -f "$cfg" ]; then
    FOUND_TW=1
    echo "### \`$cfg\`"
    echo
    echo '```'
    sed -n '1,150p' "$cfg"
    echo '```'
    echo
  fi
done
if [ "$FOUND_TW" = "0" ]; then
  # Tailwind v4 inline-in-css mode — check globals.css for @theme blocks
  echo "_(no tailwind.config.* — likely Tailwind v4 with inline @theme blocks)_"
  for css in app/globals.css src/app/globals.css styles/globals.css; do
    if [ -f "$css" ] && grep -q "@theme" "$css"; then
      echo
      echo "### \`$css\` — @theme blocks"
      echo
      echo '```css'
      awk '/@theme/,/^}/' "$css" | head -120
      echo '```'
    fi
  done
fi
echo

echo "---"
echo
echo "## shadcn config"
echo
if [ -f components.json ]; then
  echo '```json'
  cat components.json
  echo '```'
  echo

  if has jq; then
    echo "### Resolved alias paths"
    echo
    echo '```'
    jq -r '.aliases | to_entries[] | "\(.key): \(.value)"' components.json 2>/dev/null
    echo '```'
  fi
else
  echo "_(no components.json — shadcn not initialized; run \`npx shadcn@latest init\` before fetching shadcn components)_"
fi
echo

echo "---"
echo
echo "## Fonts in use"
echo
echo "### \`next/font\` imports"
echo
echo '```'
grep -rn "next/font" app/ src/app/ pages/ 2>/dev/null | head -30 || echo "(no next/font imports found)"
echo '```'
echo
echo "### Other font hints (Google Fonts links, @font-face)"
echo
echo '```'
{
  grep -rn "fonts.googleapis" app/ src/app/ public/ styles/ 2>/dev/null
  grep -rn "@font-face" styles/ src/styles/ app/ src/app/ 2>/dev/null
} | head -10 || echo "(none found)"
echo '```'
echo

echo "---"
echo
echo "## Theme provider"
echo
echo '```'
grep -rn "ThemeProvider\|next-themes" app/ src/app/ components/ src/components/ 2>/dev/null | head -10 || echo "(no theme provider detected)"
echo '```'
echo

echo "---"
echo
echo "## Existing components"
echo
echo "### shadcn-style components"
echo
echo '```'
{
  ls components/ui/ 2>/dev/null
  ls src/components/ui/ 2>/dev/null
} 2>/dev/null | sort -u | head -40 || echo "(no components/ui directory)"
echo '```'
echo
echo "### Magic UI"
echo
echo '```'
{
  ls components/magicui/ 2>/dev/null
  ls src/components/magicui/ 2>/dev/null
} 2>/dev/null | sort -u | head -40 || echo "(no components/magicui directory)"
echo '```'
echo

echo "---"
echo
echo "## Package detection"
echo
if [ -f package.json ]; then
  if has jq; then
    echo "### UI-related dependencies"
    echo
    echo '```'
    jq -r '
      (.dependencies // {}) + (.devDependencies // {}) |
      to_entries[] |
      select(.key | test("(?i)(shadcn|radix|magicui|aceternity|mantine|heroui|cult-ui|tremor|recharts|tanstack|framer-motion|gsap|next-themes|sonner|lucide|tailwind|class-variance|clsx|tw-merge|@hookform|zod|cmdk|@kuma-ui|@ark-ui|park-ui|daisyui)")) |
      "\(.key): \(.value)"
    ' package.json
    echo '```'
  else
    echo "_(install jq for package summary)_"
  fi
fi
echo

cat <<'EOF'

---

## Usage

Read the tokens above. When fetching a component:

1. **Use existing CSS variables** — `bg-background`, `text-foreground`, `text-muted-foreground`, `border-border`, `bg-primary`, etc. — never hardcoded hex.
2. **Use existing Tailwind theme values** — colors, spacing, radii defined in `tailwind.config`.
3. **Use existing fonts** — reference via Tailwind class (`font-sans`, `font-serif`, custom families), not hardcoded `style={{ fontFamily }}`.
4. **Match existing component directory** — drop new shadcn components in the same path as existing ones (check the alias paths above).

If a token you need doesn't exist, add it to the theme **first** (extend tailwind.config or add a CSS variable), then use it. Never branch with a one-off value.
EOF
