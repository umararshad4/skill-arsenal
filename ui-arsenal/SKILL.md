---
name: ui-arsenal
description: Premium component-library expert for React + Next.js + Tailwind. Knows shadcn/ui, Radix, HeroUI, Magic UI, Aceternity, ReactBits, 21st.dev, Tailwind UI, Cult UI, Tremor, Recharts, TanStack Table — their install paths, doc URLs, decision boundaries, and how to fetch live component source. Use when the user asks to add/build/install a UI component, section, block, hero, pricing, navbar, footer, form, chart, table, dashboard, bento, marquee, dock, animated background, or asks "which library should I use for X", "pull this component from Y", "find a top-tier component for Z", or wants to integrate components from any of the listed libraries.
---

# UI Arsenal

A curated knowledge layer over the best React + Next.js + Tailwind component libraries. Job: **pick the right source, fetch the live code, adapt it to the project, integrate cleanly** — then hand off to a taste-skill for polish.

## When to load reference files

- **Library URL, install command, compatibility note** → [LIBRARIES.md](LIBRARIES.md)
- **About to fetch + integrate a component** → [WORKFLOWS.md](WORKFLOWS.md)
- **Building a known pattern** (hero, pricing, dashboard) → [PATTERNS.md](PATTERNS.md)
- **Designing motion** (easing, durations, stagger, reduced-motion) → [MOTION.md](MOTION.md)
- **Building any async surface** (forms, lists, dashboards, tables) → [STATES.md](STATES.md)
- **About to report "done"** → [QUALITY-GATE.md](QUALITY-GATE.md) — run every check

Don't preload all six. The decision matrix below covers most requests; load references on demand.

## Decision matrix (the core)

| User asks for | Use | Why |
|---|---|---|
| Button, Input, Dialog, Dropdown, Form, Sheet, Tabs, Toast | **shadcn/ui** | Composable, accessible (Radix-based), themeable, owned source |
| Animated hero text, sparkles, beam, meteors, globe, marquee, dock, bento, number-ticker | **Magic UI** | Shadcn-compatible CLI, motion-tuned, drop-in |
| Spotlight cards, infinite-moving-cards, 3D card, background-gradient-animation, world-map | **Aceternity UI** | Framer Motion heavy, hero/landing showpieces |
| Animated text/links, scroll effects, fluid blobs, particle backgrounds | **ReactBits** | Niche motion components, jsrepo CLI |
| Search "any component anywhere, ranked" | **21st.dev** | Marketplace aggregator — use when shadcn/Magic UI don't have it |
| Marketing blocks (paid OK) | **Tailwind UI** | Official premium, polished but generic — combine with taste-skill |
| Animated shadcn-style cards, modals with motion | **Cult UI** | shadcn-compatible animated variants |
| Dashboard cards, KPIs, area/bar/donut charts (high-level) | **Tremor** | Opinionated dashboard primitives |
| Custom chart with full control | **Recharts** (direct) or **shadcn charts** (Recharts + theme tokens) | Composable, the shadcn `chart.tsx` wraps it |
| Sortable/filterable/paginated table | **TanStack Table** + shadcn `data-table.tsx` | Headless logic + themed UI |
| Modal/Popover/Tooltip with full a11y, no styles | **Radix Primitives** direct | Only when shadcn's wrapper is too opinionated |
| Complete monolithic component lib (Button, Card, Modal all from one source) | **HeroUI** | Use only on greenfield — **conflicts with shadcn/Magic UI**, do not mix |

## Hard rules

1. **Default stack = shadcn/ui + Magic UI + Aceternity.** They share a Tailwind/Radix DNA and compose cleanly. Pick this unless the user explicitly wants HeroUI.
2. **Never mix HeroUI with shadcn.** Different theming systems, different component philosophies. Pick one.
3. **Always fetch live** — use WebFetch on the official doc URL, don't recite from memory. Library code changes; URLs in [LIBRARIES.md](LIBRARIES.md) are stable, the code on them is not.
4. **Adapt before pasting** — match project's Tailwind config, theme tokens (`bg-background` not `bg-white`), font variables (`font-sans` not hardcoded), and existing `cn()` utility path.
5. **Verify install state** before adding — check `components.json` for shadcn config, check `package.json` for existing deps. Don't reinstall what's there.
6. **Hand off design polish** — after the component lands and renders, invoke a taste-skill (`soft-skill` for premium agency feel, `brutalist-skill` for industrial, `minimalist-skill` for editorial, `gpt-taste` for motion-heavy) to lift it from "drop-in" to "shipped."

## Anti-patterns — the AI-generic tells

Before fetching anything, internalize what makes UIs look AI-generated. Top-notch almost always means **breaking** these defaults:

- **`shadow-md` on every card** — flat or varied elevation reads more premium. Shadow is hierarchy, not decoration.
- **Every section `py-24`** — vary rhythm: 16 / 24 / 32 / 48 / 64. Different sections, different breathing.
- **`rounded-lg` everywhere** — use a radius scale: sm (4px) for inputs, md (8px) for cards, xl/2xl (16–24px+) for hero blocks.
- **Inter + Geist with nothing else** — premium needs character. Pair a display face (Fraunces, Instrument Serif, Switzer, Cabinet Grotesk, PP Editorial) with the body.
- **`gray-500` for all secondary text** — build a real hierarchy: foreground / foreground-muted / foreground-subtle. One color for everything = generic.
- **Centered hero with subhead beneath** — the AI tutorial default. Try left-aligned asymmetric, eyebrow + display headline + side-floated body, or split-pane.
- **3-column pricing, always** — break the grid. 2 + 1 featured, vertical stack, or full-width Enterprise row.
- **Identical CTA weight everywhere** — primary should dominate (filled, larger); secondary should recede (ghost, smaller). Hierarchy = scannability.
- **Lucide for every icon** — mix in custom marks, illustrated accents, or commit deliberately to one alternative (Phosphor, Iconoir, Tabler).
- **Lorem ipsum copy** — write real, specific copy at draft time. Generic copy makes generic UI regardless of layout quality.
- **Stock-photo people on white** — use product imagery, abstract gradients, or none. Never the smiling-stock-woman.
- **Default browser focus rings** — design a branded ring style. Default outline screams "unfinished."

If the fetched component contains any of these, override during the [WORKFLOWS.md](WORKFLOWS.md) adaptation step. The component is the **foundation**, not the finished UI.

## Quick start

User: *"Add a pricing section."*

1. Check [PATTERNS.md](PATTERNS.md) → pricing recipe says shadcn blocks first, fall back to 21st.dev.
2. WebFetch `https://ui.shadcn.com/blocks` → find pricing block → grab source.
3. Run [WORKFLOWS.md](WORKFLOWS.md) adapt step: swap hardcoded colors for theme tokens, match project's font.
4. Install: `npx shadcn@latest add [block-url]`.
5. Place at `components/sections/pricing.tsx`, import into page.
6. Hand off to `soft-skill` for typography/spacing polish.

## What this skill does NOT do

- It is **not a design system** — for typography/spacing/color *rules*, use `taste-skill`, `soft-skill`, `brutalist-skill`, `minimalist-skill`, `gpt-taste`.
- It does **not generate components from scratch** — it sources from libraries. For from-scratch generation, use `image-to-code-skill` or `stitch-skill`.
- It does **not redesign existing UIs** — for that, use `redesign-skill`.

Coordinate with these — don't duplicate them.
