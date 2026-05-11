# Composition Patterns

Battle-tested recipes for common UI surfaces. Each one names the libraries to combine, the order to fetch them, and the gotchas. Use these as the starting point — then run the result through a taste-skill.

## States in every recipe

Every async surface needs loading / empty / error / success — that's what separates demo-grade from product-grade. Wire these per [STATES.md](STATES.md). Quick map:

| Pattern | Critical states |
|---|---|
| Form | Loading (button spinner) + error (per field + submit) + success (toast + reset) |
| Data table | Loading (skeleton rows) + empty (CTA or "Clear filters") + error (retry block) |
| Dashboard | Loading (skeleton cards) + empty (per-metric) + error (per-card retry) |
| Pricing | Loading (checkout init) + error (payment) + success (redirect/toast) |
| Search | Loading (skeleton results) + empty ("No results for X") + error (retry) |
| File upload | Progress (real %) + error (per-file retry) + success (per-file confirm) |
| Modal / sheet | Skeleton body + inline error inside + close + toast on success |
| Hero / marquee / CTA | Usually static — no state coverage needed |

Skipping these is the most common AI-generic tell. Verify before reporting done.

## Landing hero (high-impact)

**Stack**: Aceternity `spotlight` OR `background-beams` + Magic UI `animated-shiny-text` (eyebrow) + custom `<h1>` + Magic UI `shimmer-button` (primary CTA) + shadcn `button` variant=ghost (secondary)

**Order**:
1. Fetch Aceternity background component → place as absolute-positioned layer
2. Fetch Magic UI `animated-shiny-text` for the small eyebrow above the headline
3. Write the `<h1>` directly — don't outsource the headline to a library (typography is the hero's job)
4. Fetch Magic UI `shimmer-button` for CTA

**Gotchas**:
- Aceternity backgrounds are `position: absolute` — wrap in a `relative` container with explicit height
- Don't combine 3+ animated backgrounds — pick one focal effect
- Headline font: use a serif or display font from `next/font` for contrast against the body sans

**Polish**: `gpt-taste` if motion-heavy, `soft-skill` for premium calm.

---

## Pricing section

**Stack**: shadcn `blocks` pricing OR 21st.dev pricing block

**Order**:
1. WebFetch https://ui.shadcn.com/blocks → scroll to pricing section
2. If shadcn's options don't fit, search 21st.dev for "pricing"
3. Install the block via CLI
4. Replace placeholder copy with project's actual tiers/features
5. Wire up CTAs to checkout flow (Stripe, Lemon Squeezy, etc.)

**Gotchas**:
- Pricing blocks often hardcode 3 tiers — if you need 2 or 4, the grid math breaks (`md:grid-cols-3` won't center 2 cards). Switch to `md:grid-cols-2 lg:grid-cols-4` and adjust card max-width.
- "Most popular" badge is usually a separate utility — preserve the styling when adapting

---

## Navbar (marketing site)

**Stack options**:
- **Animated**: Magic UI `dock` (Mac-style hover dock) — great for apps with 5–8 nav items
- **Standard**: shadcn `navigation-menu` — dropdown-capable, accessible
- **Bold**: Aceternity `floating-navbar` or `navbar-menu` — appears on scroll

**Order**:
1. Pick based on site personality (dock = playful, navigation-menu = enterprise, floating = creative)
2. Fetch the component
3. Wrap nav links with `next/link` (the docs use `<a>` — always swap to `Link` in Next.js)
4. Add mobile menu: shadcn `sheet` triggered by a hamburger `<Button>`

**Gotchas**:
- Next.js: replace `<a href>` with `<Link href>` after pasting — never miss this
- Sticky nav: wrap in `<header className="sticky top-0 z-50 ...">` — most components don't include this

---

## Footer

**Stack**: shadcn `blocks` footer OR write directly with Tailwind grid

**Order**: footers are rarely worth a library — a 4-column Tailwind grid with `lucide-react` social icons is faster than fetching. Only fetch if user wants animated/elaborate.

---

## Form (signup, contact, checkout)

**Stack**: shadcn `form` + `react-hook-form` + `zod` + `@hookform/resolvers` + shadcn `input` / `textarea` / `select` / `button` + `sonner` (toast)

**Order**:
1. `npx shadcn@latest add form input textarea select button` (form pulls in the others)
2. `npm install react-hook-form zod @hookform/resolvers sonner`
3. WebFetch https://ui.shadcn.com/docs/components/form for the latest pattern (the API has changed across versions)
4. Define zod schema → infer types → pass to `useForm({ resolver: zodResolver(schema) })`
5. Add `<Toaster />` to root layout (sonner)

**Gotchas**:
- shadcn's form pattern uses `<FormField control={form.control} name="..." render={({ field }) => ...} />` — don't shortcut this, accessibility depends on it
- Async server actions: wrap `onSubmit` in a `startTransition` if using Next.js server actions

---

## Dashboard (app interior)

**Option A — opinionated, fast**: Tremor
1. `npm install @tremor/react`
2. Configure Tailwind per Tremor docs
3. Use `<Card>`, `<Metric>`, `<AreaChart>`, `<BarList>` directly

**Option B — full control, shadcn-aligned**: shadcn cards + shadcn charts
1. `npx shadcn@latest add card chart`
2. `npm install recharts`
3. Build KPI cards as `<Card>` with custom content
4. Charts inside `<ChartContainer>` wrappers

Pick A if speed matters and the brand is generic. Pick B if the dashboard needs to feel custom or match an existing shadcn site.

---

## Data table

**Stack**: shadcn `table` + `data-table` wrapper + `@tanstack/react-table`

**Order**:
1. `npx shadcn@latest add table`
2. `npm install @tanstack/react-table`
3. WebFetch https://ui.shadcn.com/docs/components/data-table → copy the entire DataTable component into `components/ui/data-table.tsx`
4. Define `columns.tsx` exporting `ColumnDef<YourType>[]`
5. Use `<DataTable columns={columns} data={rows} />` in your page

**Gotchas**:
- Sorting/filtering/pagination are opt-in features — start with sorting only, layer the rest
- Row selection requires a separate column with a checkbox — see shadcn examples

---

## Bento grid (feature showcase)

**Stack**: Magic UI `bento-grid` OR Aceternity `bento-grid`

**Order**:
1. Fetch the chosen bento — both are good, Magic UI's tends to be cleaner, Aceternity's more elaborate
2. Replace placeholder content (icons, images, mini-charts) with project-specific visuals
3. Vary card heights/spans deliberately — uniform grid kills the "bento" effect

**Gotchas**:
- Don't put 12 cards in a bento — 4 to 7 is the sweet spot
- Each card should have a *different* visual character (icon, image, chart, text-only) — repetition flattens the design

---

## Marquee / logo cloud / testimonials carousel

**Stack**: Magic UI `marquee` OR Aceternity `infinite-moving-cards`

**Order**: fetch, drop in, pass an array of items. Both are one-liners.

**Gotcha**: pause on hover is usually opt-in via a prop — enable it for testimonials (users want to read), disable for pure logo clouds.

---

## CTA section (end-of-page conversion)

**Stack**: shadcn `card` + Magic UI animated background (`retro-grid`, `ripple`, or `dot-pattern`) + shadcn `button`

**Order**: this is a 30-line component, don't over-fetch. Write the layout directly, only fetch the animated background.

---

## Animated text effects

| Need | Component | Library |
|---|---|---|
| Gradient sweep across heading | `animated-shiny-text` | Magic UI |
| Letter-by-letter reveal | `SplitText` | ReactBits |
| Blurred-in entrance | `BlurText` | ReactBits |
| Sparkle accent on a word | `sparkles-text` | Magic UI |
| Number count-up | `number-ticker` | Magic UI |
| Aurora-gradient text | `GradientText` | ReactBits |

Use sparingly — one animated text element per section, max.

---

## When in doubt

- Need it fast and accessible → **shadcn/ui**
- Need it to *wow* on first scroll → **Aceternity** for backgrounds, **Magic UI** for motion details
- Can't find it in the above → search **21st.dev**
- Building charts → **shadcn charts** (Recharts under the hood)
- Building tables → **TanStack Table** + **shadcn data-table** wrapper
- Building a dashboard fast → **Tremor**
