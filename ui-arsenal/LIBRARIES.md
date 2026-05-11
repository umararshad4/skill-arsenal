# Library Registry

Stable URLs and install commands for every supported library. Always WebFetch the doc page before quoting code — these URLs persist, the code behind them changes.

## Production Primitives

### shadcn/ui — **default workhorse**
- Docs root: https://ui.shadcn.com
- Component index: https://ui.shadcn.com/docs/components
- Block index: https://ui.shadcn.com/blocks
- Chart docs: https://ui.shadcn.com/docs/components/chart
- Component page pattern: `https://ui.shadcn.com/docs/components/{name}` (e.g. `/button`, `/dialog`, `/data-table`)
- Install one: `npx shadcn@latest add {name}` (e.g. `npx shadcn@latest add button dialog form`)
- Install block: `npx shadcn@latest add {full-block-url}`
- Init in new project: `npx shadcn@latest init`
- Config file: `components.json` (must exist before `add`)
- Output dir: `components/ui/`
- Built on: Radix Primitives + Tailwind + class-variance-authority
- Theming: CSS vars in `globals.css` (`--background`, `--foreground`, `--primary`, etc.)

### Radix Primitives — **only when shadcn is too opinionated**
- Docs: https://www.radix-ui.com/primitives/docs/overview/introduction
- Component pattern: `https://www.radix-ui.com/primitives/docs/components/{name}`
- Install: `npm install @radix-ui/react-{name}` (e.g. `@radix-ui/react-dialog`)
- Use case: building a custom wrapper that shadcn doesn't expose, or when you need raw a11y primitives with zero default styling

### HeroUI (formerly NextUI) — **greenfield only, do not mix**
- Docs: https://www.heroui.com/docs/guide/introduction
- Component index: https://www.heroui.com/docs/components/overview
- Install: `npm install @heroui/react framer-motion`
- Provider required: wrap app in `<HeroUIProvider>`
- ⚠️ **Incompatible with shadcn/ui** — different theming, different design language. If `components.json` exists, prefer shadcn.

## Premium Animated

### Magic UI — **shadcn-compatible animations**
- Docs root: https://magicui.design/docs
- Component index: https://magicui.design/docs/components/marquee (browse sidebar)
- Component page pattern: `https://magicui.design/docs/components/{name}`
- Install: `npx shadcn@latest add "https://magicui.design/r/{name}.json"`
- Output dir: `components/magicui/`
- Notable: marquee, dock, bento-grid, animated-beam, animated-list, sparkles-text, number-ticker, globe, meteors, retro-grid, ripple, shimmer-button, border-beam, animated-shiny-text

### Aceternity UI — **hero / landing showpieces**
- Docs root: https://ui.aceternity.com
- Component index: https://ui.aceternity.com/components
- Component page pattern: `https://ui.aceternity.com/components/{name}`
- Install: usually manual copy-paste from doc page (some have shadcn registry URLs)
- Required dep: `framer-motion` (most components)
- Output dir: `components/ui/` (manual placement)
- Notable: spotlight, background-beams, infinite-moving-cards, 3d-card, background-gradient, world-map, sparkles, wavy-background, lamp, vortex, tracing-beam, hero-parallax

### ReactBits — **niche motion**
- Docs root: https://www.reactbits.dev
- Component index: https://www.reactbits.dev/text-animations/split-text (browse sidebar)
- Install: `npx jsrepo add @reactbits/{Category}/{Name}` (e.g. `@reactbits/TextAnimations/SplitText`)
- Categories: TextAnimations, Animations, Components, Backgrounds
- Notable: SplitText, BlurText, ShinyText, GradientText, Aurora, Beams, FluidGlass, MagnetLines

## Marketplaces

### 21st.dev — **the search layer**
- Docs root: https://21st.dev
- Search: https://21st.dev/?tab=components or `https://21st.dev/?q={query}`
- Install: `npx shadcn@latest add "{component-registry-url}"` (each component has a registry JSON URL on its page)
- Use when shadcn + Magic UI + Aceternity don't have what you need — it aggregates all of them plus community submissions

### Tailwind UI — **paid, polished, generic**
- Docs root: https://tailwindui.com
- Sections: https://tailwindui.com/components (Marketing, Application UI, Ecommerce)
- Access: requires paid license — if user has access, they copy code directly from their dashboard
- Use case: enterprise marketing pages where speed matters more than originality; always run through a taste-skill afterward

### Cult UI — **animated shadcn variants**
- Docs root: https://www.cult-ui.com/docs/components/intro
- Component index: https://www.cult-ui.com/docs (sidebar lists components)
- Install: `npx shadcn@latest add "https://cult-ui.com/r/{name}.json"` (verify URL pattern on doc page)
- Notable: dynamic-island, family-button, expandable-card, side-panel, shift-card

## Data / Dashboard

### Tremor — **opinionated dashboard kit**
- Docs root: https://tremor.so/docs/getting-started/installation
- Component index: https://tremor.so/docs/ui/area-chart (browse sidebar)
- Blocks: https://blocks.tremor.so
- Install: `npm install @tremor/react` + Tailwind config additions (see docs)
- Required: extend `tailwind.config.js` with Tremor's color palette
- Notable: AreaChart, BarChart, DonutChart, Card, Metric, ProgressBar, Tracker, BarList

### Recharts — **composable charts, the foundation**
- Docs root: https://recharts.org/en-US/api
- Examples: https://recharts.org/en-US/examples
- Install: `npm install recharts`
- Pairs with: shadcn's `components/ui/chart.tsx` which wraps Recharts in themed containers
- Use directly when you need full control; use via shadcn chart when you want theme tokens

### TanStack Table — **headless table logic**
- Docs root: https://tanstack.com/table/latest/docs/introduction
- Examples: https://tanstack.com/table/latest/docs/framework/react/examples/basic
- Install: `npm install @tanstack/react-table`
- Pairs with: shadcn's `data-table.tsx` (https://ui.shadcn.com/docs/components/data-table) — copy that wrapper, plug your columns
- Use case: every sortable/filterable/paginated table in the app

## Supporting libraries (almost always needed)

- **framer-motion**: `npm install framer-motion` — required by Magic UI, Aceternity, Cult UI
- **lucide-react**: `npm install lucide-react` — default icon set for shadcn
- **class-variance-authority** + **clsx** + **tailwind-merge**: usually installed by `shadcn init`
- **react-hook-form** + **zod** + **@hookform/resolvers**: required by shadcn `form` component
- **next-themes**: for shadcn dark mode toggle
- **sonner**: shadcn's preferred toast lib (newer projects); older use `radix-ui/react-toast`

## Alternative component libraries

Beyond the default stack — use when the project has specific constraints.

### Mantine — full alternative to shadcn
- Docs: https://mantine.dev
- Component index: https://mantine.dev/core/button (browse sidebar)
- Install: `npm install @mantine/core @mantine/hooks @emotion/react`
- Built-in: 100+ components, hooks, form lib, notifications, modals, dates, charts
- Use case: want batteries-included library; don't want to own component source
- Don't mix with shadcn — same conflict pattern as HeroUI

### Park UI — Ark UI + Panda CSS
- Docs: https://park-ui.com
- Component index: https://park-ui.com/react/docs/components/button
- Install: requires Panda CSS setup (`npx panda init`) — see docs
- Built on: Ark UI primitives + Panda CSS (zero-runtime, type-safe styling)
- Use case: want headless primitives + your own design system, prefer Panda over Tailwind

### daisyUI — pure Tailwind plugin
- Docs: https://daisyui.com
- Component index: https://daisyui.com/components
- Install: `npm install -D daisyui` + add to `tailwind.config.js` plugins
- Use case: pure CSS components, no React deps, theme via Tailwind config
- Combines OK with shadcn but doubles the design language — pick one as primary

### Ark UI — headless primitives (cross-framework)
- Docs: https://ark-ui.com
- Component index: https://ark-ui.com/react/docs/components/accordion
- Install: `npm install @ark-ui/react`
- Use case: headless like Radix, but works in React/Vue/Solid with a broader primitive set
- Pairs with: any styling system (Tailwind, Panda, CSS modules)

### Kuma UI — zero-runtime CSS-in-JS
- Docs: https://www.kuma-ui.com
- Component index: https://www.kuma-ui.com/docs/Components/Button
- Install: `npm install @kuma-ui/core @kuma-ui/next-plugin`
- Use case: want CSS-in-JS DX (styled-components-like) with zero runtime cost (compiled at build)
- Niche — Tailwind is the default; Kuma fits teams that want CSS-in-JS DX without the perf hit

## Compatibility quick-check

| Combine | Status |
|---|---|
| shadcn + Magic UI + Aceternity + Cult UI | OK — all share Tailwind + Radix DNA |
| shadcn + Tremor | Warning — Tremor has its own color palette, namespace or override |
| shadcn + Recharts + TanStack Table | OK — shadcn provides the wrappers |
| shadcn + Ark UI primitives | OK — headless primitives drop in alongside Radix |
| shadcn + daisyUI | Warning — both Tailwind-based, works but two design languages, pick a primary |
| shadcn + HeroUI / Mantine / Park UI / Kuma UI | Don't — overlapping component libraries, pick one |
| HeroUI + Magic UI | Don't — Magic UI assumes shadcn theming |
| Tailwind UI + anything | OK — pure Tailwind, theme-agnostic |
| ReactBits + shadcn | OK — ReactBits is style-isolated |
