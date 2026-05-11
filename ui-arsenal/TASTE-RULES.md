# Premium Taste Rules

Numeric and specific. Following these mechanically produces premium-grade output **even without visual judgment** — these are the rules senior designers internalize as second nature, written down.

**These supersede defaults from the fetched libraries.** A shadcn Button at 36px height is not wrong, but for a hero CTA on a marketing page it's too small. Override.

---

## Typography

### Hero headline (landing page H1)
- **Desktop**: 56px minimum. Ideal **64–96px**. Ambitious display 96–128px.
- **Mobile**: 36px minimum. Ideal 44–56px.
- **Weight**: 600 minimum. Ideal **700–800**. 900 for extreme statement.
- **Line-height**: **0.9–1.05** (tight). Never use default 1.5 for display sizes.
- **Letter-spacing**: **−0.02em to −0.04em** (tighten — large type's natural tracking is too loose).
- **Color contrast on background**: ≥ 12:1 (true black on white = 21:1).

### Section heading (H2)
- Desktop: 36–48px. 56px for important sections.
- Mobile: 28–36px.
- Weight: 600–700.
- Line-height: 1.05–1.2.
- Letter-spacing: −0.01 to −0.02em.

### Subhead / lede
- 18–24px on marketing pages.
- Weight: 400–500.
- Line-height: 1.4–1.5.
- Color: foreground-muted (not foreground).
- Max-width: 50–65ch.

### Body text
- **Marketing pages**: 17–20px (default 16px is too small for marketing — bump it).
- **App UI**: 14–16px.
- **Line-height**: **1.5–1.7** for paragraphs. Never below 1.4.
- **Max line length**: **60–75ch** (use `max-w-prose` or `max-w-[65ch]`).
- **Weight**: 400 default, 500 reads slightly more polished on web.

### Type pairing rules
- **Pair contrasting**: serif + sans, or distinctive sans + neutral sans. Never two neutral sans together (Inter + Geist + system-ui all blur — pick one).
- **2025 display fonts that signal premium**: Fraunces, Instrument Serif, PP Editorial, PP Neue Montreal, Switzer, Cabinet Grotesk, Söhne, Migra, Tobias, Reckless, Author, Editorial New.
- **2025 body fonts**: Inter, Geist, IBM Plex Sans, Söhne, Aktiv Grotesk, Untitled Sans. Pick ONE.

### Numerals
- **Tabular** for prices, tables, dashboards: `font-variant-numeric: tabular-nums`.
- **Lining** for headlines; **old-style** for body when font supports.

---

## Spacing

### Vertical rhythm scale (use ONLY these values)
`4 / 8 / 12 / 16 / 24 / 32 / 48 / 64 / 96 / 128 / 192`
(Tailwind: `1 / 2 / 3 / 4 / 6 / 8 / 12 / 16 / 24 / 32 / 48`)

Never use `mt-[17px]` or `gap-[37px]`. If you find a value that doesn't fit the scale, pick the nearest scale value.

### Section padding (marketing)
- **Desktop**: `py-24` (96px) minimum. Ideal `py-32` (128px). `py-48` (192px) for hero.
- **Mobile**: `py-16` (64px) minimum. Ideal `py-20–24`.
- **Side padding**: `px-4` mobile, `px-8` tablet, `px-12–16` desktop.

### Container max-width
- **Marketing**: 1280–1440px.
- **App content**: 1024–1280px.
- **Text-only content**: max-w-prose (~65ch) — never full-bleed text.

### Element gaps
- Inside a card: 16–24px.
- Between cards in a grid: 16–24px mobile, 24–32px desktop.
- Between heading and body: 16–24px.
- Between body and CTA: 24–32px.
- Between sibling sections: 96–192px (section-level rhythm).

---

## Color

### Restraint (the hardest rule for AI)
- **1 primary** brand color.
- **1 accent** (used sparingly — < 10% of UI).
- **1 neutral scale** (9–11 shades from near-white to near-black).
- That's it. No rainbow. Each additional hue dilutes the design.

### "Black" is rarely #000
- **Body text "black"**: `#0a0a0a` or `#050505` — pure black is harsh on screens.
- **Background "white"**: `#fafafa` or `#f5f5f5` for warm UIs. `#ffffff` is fine for clinical.
- **Exception**: dark mode background can be `#000` for OLED screens (true black is deliberate).

### Text color hierarchy (mandatory ≥ 3 levels)
- **Primary** (`text-foreground`): 90–100% opacity — headings, key body
- **Secondary** (`text-foreground/70` or `text-muted-foreground`): 60–70% — description, supporting
- **Tertiary** (`text-foreground/50`): 40–50% — metadata, captions, timestamps
- **Disabled**: 30–40%

Never use `text-gray-500` for every secondary thing. Build the hierarchy.

### Contrast targets
- Body text on background: **7:1 (AAA)** for premium. Never below 4.5:1.
- Large headings: ≥ 4.5:1 minimum (AA Large).
- Secondary text: ≥ 4.5:1.
- Disabled state: ≥ 3:1 (it's disabled, but still readable).

### Brand color usage
- Primary should appear in **≤ 20%** of viewport at any time.
- Use color for **action**, not for decoration.
- Saturated brand color on saturated background = harsh. Tone one of them down.

---

## Borders & Radii

### Radius scale (use ONLY these)
`0 / 2 / 4 / 6 / 8 / 12 / 16 / 24 / 9999`

- **Inputs / small buttons**: 6–8px
- **Standard cards**: 8–12px
- **Large feature cards**: 16–24px
- **Hero containers / sections**: 24–32px or 0 (flush full-bleed is also premium)
- **Avatars / pills**: 9999

**Mandatory: use ≥ 3 different radii in the same project.** Identical radius everywhere = flat = generic.

### Borders
- **1px** for cards, inputs (default).
- **2px** for emphasis (focus rings, errors, selected state).
- Color: `border-border` (theme token), not `border-gray-200` directly.
- For warmth: 5–10% opacity of foreground color over background.

---

## Shadows

### Use as hierarchy, not decoration
- **Card at rest**: no shadow OR very subtle (1–2px y-offset, 4–8% black).
- **Card on hover**: subtle elevation bump.
- **Modal / popover**: medium (8–16px offset, 15–20% alpha).
- **Hero callout**: dramatic (24–48px offset, 25–30% alpha).

### Multi-layer shadows (the premium tell)
Combine 2–3 box-shadows for depth:
```css
box-shadow:
  0 1px 2px rgba(0, 0, 0, 0.04),
  0 4px 8px rgba(0, 0, 0, 0.04),
  0 16px 32px rgba(0, 0, 0, 0.04);
```

### Color the shadow
- Pure black shadow looks generic.
- Tint shadow toward primary or background hue at 5–10% saturation.
- Example: instead of `rgba(0,0,0,0.1)`, use `rgba(20, 30, 80, 0.1)` if primary is blue.

---

## Motion (cross-reference [MOTION.md](MOTION.md))

- **Duration**: 150–300ms for UI, 400–800ms for hero entrances.
- **Easing**: `cubic-bezier(0.16, 1, 0.3, 1)` (premium default ease-out).
- **Never `linear`** for UI motion (only marquees / progress).
- **Stagger increment**: 50–80ms, total < 1s for lists.
- **Reduced motion**: instant fallback (0.01ms).

---

## Layout (anti-generic enforcement)

### Asymmetry beats symmetry
- Off-center the eyebrow, headline, or CTA in hero.
- Don't center every section. Try left-aligned with negative space on the right.
- Editorial: float images out of the column with deliberate margin offsets.

### One focal point per viewport
- Don't have 3 equally-weighted elements competing in hero.
- Make ONE thing dominant (usually the headline). Others recede.

### Negative space is the design
- Empty sections aren't unfinished — they're breathing.
- Don't fill every cell of a grid; leave some blank.

### Break the grid deliberately
- Hero: text on 7-col + image on 5-col is more interesting than 6/6.
- Pricing: 2 + 1 featured (center tier larger) beats 3 equal.
- Testimonials: bento with staggered card sizes beats uniform grid.

---

## Imagery

### Sources
- **Original photography** (best — bespoke).
- **AI-generated** (Midjourney, DALL-E) for abstractions, gradients, brand-coherent visuals.
- **Unsplash** for editorial — filter restrained, photographic, not over-saturated.
- **Custom illustration** (Spline 3D, Rive animation) for distinctive identity.
- **Avoid at all costs**: stock photo people on white backgrounds, smiling office workers, generic "diverse team" shots.

### Treatment
- Subtle gradient overlay or color cast for cohesion with brand.
- Filter / desaturate slightly if image is too vibrant.
- Round corners per the radius scale.
- Above-the-fold: `priority` prop. Below: lazy.

---

## Icons

### Pick ONE system per project (mixing reads cheap)
- **Lucide** — shadcn default. Fine but generic.
- **Phosphor** — personality, multiple weights.
- **Iconoir** — clean, geometric.
- **Tabler** — extensive set.
- **Custom SVG** — for brand marks and feature illustrations.

### Sizing
- Inline with body text: 16–18px (match text x-height).
- UI controls (buttons, nav): 20–24px.
- Feature icons (in cards): 32–48px.
- Decorative / hero-adjacent: 64px+.

---

## CTA buttons

### Primary
- **Height**: 44–56px (touch-friendly + hero-scale).
- **Padding**: 24–32px horizontal.
- **Font**: 16–18px, weight 600.
- **Background**: brand primary, full opacity.
- **Hover**: 5–10% darker OR subtle scale (1.02), NOT both.

### Secondary
- Same height as primary (alignment).
- Background: transparent OR muted.
- Border: 1px subtle OR none (ghost).
- Font weight: 500 (slightly lighter than primary).

### Tertiary
- Inline text link with underline or arrow.
- Same color as primary (for affordance).

### Hierarchy
- **One primary per section maximum.**
- Multiple secondaries OK if they're peer choices.
- Never two equally-weighted CTAs side-by-side (always one dominates).

---

## Copy / content

The skill is mostly about visual rules, but generic copy makes generic UI regardless of layout quality. Two minimum rules:

- **Never ship Lorem ipsum.** Write specific copy at draft time, even if it's a placeholder you'll refine.
- **Avoid marketing-speak**: "Innovative solutions for modern teams", "Empowering businesses to do more", "Streamline your workflow". These read as AI-generated. Be specific — what does the product actually do?

For deeper copy work, see the `content-arsenal` skill (roadmap).

---

## How to apply

When you fetch a component:
1. **Audit every value** (font size, padding, radius, color, shadow).
2. **Compare against these rules**.
3. **Override** any value that violates the rule.
4. **Re-render** in dev server.
5. **Cross-check** [SELF-CHECK.md](SELF-CHECK.md) Step 4 — quote the actual numbers you used.

When in doubt, the premium direction is almost always:
- **Bigger** headlines
- **More** whitespace
- **Fewer** colors
- **Tighter** tracking on display
- **Looser** line-height on body
- **Higher** contrast on text
- **More** asymmetry in layout

If your component feels safe and balanced, push further in one of those directions.
