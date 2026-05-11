# Workflows

End-to-end processes for fetching, adapting, and integrating components. Run the checklist top-to-bottom every time — skipping the project-audit step is how broken installs happen.

## Workflow A — Add a single shadcn/ui-compatible component

Use for: shadcn/ui, Magic UI, Cult UI, 21st.dev registry items.

### 1. Audit the project (do this first, every time)
- [ ] `components.json` exists? If no → `npx shadcn@latest init` (ask user to confirm before running)
- [ ] Tailwind v3 or v4? Check `tailwind.config.js`/`.ts` or CSS `@import "tailwindcss"` — affects component compatibility
- [ ] `cn()` utility location? Usually `lib/utils.ts`
- [ ] Dark mode set up? Look for `next-themes` and `<ThemeProvider>` in layout
- [ ] Existing `globals.css` has CSS vars (`--background`, `--foreground`)? Required for theming

### 2. Fetch live source
- WebFetch the component's official doc URL (see [LIBRARIES.md](LIBRARIES.md) for patterns)
- Pull the **code tab / "Manual" tab** content — that's the authoritative source
- Note any required deps the doc lists (framer-motion, react-hook-form, etc.)

### 3. Install via CLI
```bash
npx shadcn@latest add {component-name-or-url}
```
- For Magic UI / Cult UI / 21st.dev: use the full registry URL from the doc page
- For multiple at once: `npx shadcn@latest add button card dialog`
- **Confirm before running** — the CLI writes files and may overwrite

### 4. Verify file landed
- [ ] File exists at `components/ui/{name}.tsx` (shadcn) or `components/magicui/{name}.tsx` (Magic UI)
- [ ] Imports resolve (`@/lib/utils`, `@/components/ui/...`)
- [ ] No TypeScript errors in the new file

### 5. Use it
- Import into the target page/component
- Replace any hardcoded colors with theme tokens (see "Adaptation rules" below)
- Run dev server, verify it renders

### 6. Polish
- Hand off to the appropriate taste-skill for typography, spacing, and motion refinement

---

## Workflow B — Copy-paste component (Aceternity, ReactBits, Tailwind UI)

Use when there's no CLI — Aceternity (most), ReactBits non-jsrepo items, Tailwind UI snippets.

### 1. Audit (same as Workflow A step 1)

### 2. Fetch
- WebFetch the doc page
- Extract the component source (usually labeled "Code" or shown in a code block)
- Note required deps — `framer-motion` is the most common

### 3. Install deps
```bash
npm install framer-motion  # or whatever the doc lists
```

### 4. Place the file
- Aceternity convention: `components/ui/{kebab-name}.tsx`
- ReactBits convention: `components/reactbits/{Category}/{Name}.tsx`
- Confirm path before writing — don't overwrite existing files

### 5. Adapt (see "Adaptation rules")

### 6. Wire up, render, polish

---

## Workflow C — Chart or data table

### Chart (shadcn + Recharts)
1. `npx shadcn@latest add chart` — installs `components/ui/chart.tsx` wrapper
2. `npm install recharts` (if not already)
3. WebFetch https://ui.shadcn.com/docs/components/chart for the latest API
4. Build chart inside `<ChartContainer config={chartConfig}>` — config maps data keys to theme colors

### Data table (shadcn + TanStack)
1. `npx shadcn@latest add table`
2. `npm install @tanstack/react-table`
3. WebFetch https://ui.shadcn.com/docs/components/data-table — copy the `<DataTable>` wrapper into `components/ui/data-table.tsx`
4. Build `columns.tsx` per the docs (ColumnDef array)

### Dashboard (Tremor)
1. `npm install @tremor/react`
2. Update `tailwind.config.js` per https://tremor.so/docs/getting-started/installation (Tremor's content paths + safelist)
3. Import directly: `import { AreaChart, Card } from '@tremor/react'`
4. ⚠️ Tremor's `Card` and shadcn's `Card` will conflict if both imported in one file — alias one

---

## Adaptation rules (apply to every fetched component)

Before pasting, transform the fetched code:

| Find | Replace with |
|---|---|
| `bg-white`, `bg-black` | `bg-background` |
| `text-black`, `text-gray-900` | `text-foreground` |
| `text-gray-500`, `text-gray-600` | `text-muted-foreground` |
| `bg-gray-100`, `bg-gray-50` | `bg-muted` |
| `border-gray-200` | `border-border` |
| `bg-blue-500` (or any "primary brand" color) | `bg-primary` |
| Hardcoded `font-['Inter']` or `style={{fontFamily}}` | Remove — let project root font handle it |
| `cn` import from local path | Confirm path matches project's `lib/utils.ts` |
| `next/image` if project uses plain `<img>` | Keep `next/image` (this is Next.js — it's correct) |

**Don't** change: spacing scales (`p-4`, `gap-8`), border radii (`rounded-lg`), shadow utilities. Those are theme-agnostic.

**Do** preserve: `motion.div` / Framer Motion imports, Radix primitive wrappers, `forwardRef` patterns, `displayName` assignments.

---

## When the fetch fails or returns junk

- WebFetch sometimes returns the marketing shell, not the code. If you don't see a usable code block, try the component's GitHub source if linked, or try the registry JSON URL (shadcn-compatible libs expose `.json` endpoints)
- If a library is gated (Tailwind UI), ask the user to paste the snippet — don't try to bypass auth
- If a component depends on a peer dep you don't recognize, **ask** before installing

---

## Performance budget

Premium UIs can be heavy. Set the budget at build start; enforce on every component add.

### Bundle budget

| Constraint | Limit |
|---|---|
| Per-route First Load JS | ≤ 200KB |
| Total client JS | ≤ 350KB |
| Total page weight (uncached) | ≤ 1MB |
| Above-the-fold images | ≤ 5 per route |
| Custom font families | ≤ 2 families, ≤ 3 weights total |

Run `npm run build` after every significant add. Next.js prints per-route JS size — flag any regression > 30KB and investigate.

### Component-by-component cost

| Component | Approx cost (gz) | Strategy |
|---|---|---|
| Framer Motion (any) | ~30KB | Up to 3 eager per route; lazy-load further use |
| Aceternity background (most) | 5-15KB + framer-motion | Always `dynamic` import with `ssr: false` |
| Magic UI marquee / dock | ~5KB + framer-motion | Eager OK |
| Magic UI globe | ~80KB (cobe lib) | Always dynamic, defer below fold |
| Three.js component | 150KB+ | Dynamic only, never above fold |
| Recharts | ~80KB | Dynamic if not above fold |
| Tremor full | ~120KB | Dynamic, route-level code split |
| TanStack Table | ~15KB | Eager OK |

### Lazy-load rules

Use `next/dynamic` with `ssr: false` for:
- Anything WebGL (globe, three.js, shaders)
- Background animations below the fold
- Charts not visible on initial render
- Modal contents (load on open)

```tsx
import dynamic from "next/dynamic"

const Globe = dynamic(() => import("@/components/magicui/globe"), {
  ssr: false,
  loading: () => <Skeleton className="h-96 w-96 rounded-full" />,
})
```

### Image rules

- Always `next/image` — never `<img>` in Next.js
- Always set `sizes` prop for responsive images — uncapped images destroy LCP
- Default AVIF/WebP via Next.js — don't override
- Above-the-fold hero image: `priority` prop
- Below the fold: default lazy

### Font rules

- Use `next/font/google` or `next/font/local` — never `<link rel="stylesheet">` to Google Fonts
- Self-host (next/font does this automatically)
- Subset to Latin unless project is i18n'd
- Variable fonts when available — one file, every weight
- `display: 'swap'` to avoid FOIT

### Threshold for dynamic import

Any client component importing a library > 30KB gz AND not above the fold → dynamic-import it. Even if it's "just one section."

Check size with `npx bundle-phobia <package>` or inspect Next.js build output.

---

## Pre-flight checklist (before reporting done)

- [ ] Component file exists at expected path
- [ ] All imports resolve, no red squiggles
- [ ] All required deps installed (`framer-motion`, etc.)
- [ ] Hardcoded colors replaced with theme tokens
- [ ] Renders in dev server (`npm run dev` + load the page)
- [ ] Dark mode looks correct (toggle if `next-themes` is set up)
- [ ] No console errors on render
- [ ] Performance budget verified (`npm run build`, check First Load JS)
- [ ] Heavy components dynamic-imported per the rules above
- [ ] Loading / empty / error states wired per [STATES.md](STATES.md)
- [ ] Motion respects reduced-motion per [MOTION.md](MOTION.md)
- [ ] Handed off to taste-skill OR explicitly noted polish is the next step

For full quality verification (visual review, a11y audit, responsive sweep, perf), run [QUALITY-GATE.md](QUALITY-GATE.md) — that is the final gate before "done."
