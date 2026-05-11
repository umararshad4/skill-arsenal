# Motion Language

Premium UIs feel cohesive because every animation shares DNA — same easing, same durations, same intent. Mixing libraries or values is the fastest way to look amateur. Pick once, apply everywhere.

## Rule 1 — One motion library per project

Decide at the start of the build. Default is **Framer Motion** (required by Magic UI, Aceternity, Cult UI — already installed once you fetch any of them).

| Library | Use when |
|---|---|
| **Framer Motion** | Default. Pairs with Magic UI / Aceternity / Cult UI. Best React DX. |
| **GSAP + ScrollTrigger** | Scroll-driven storytelling, complex pinned timelines, parallax. Pair with `gpt-taste` skill. |
| **Motion One** | Performance-critical, smaller bundle, vanilla JS. Rare in React projects. |

**Do not** install GSAP alongside Framer Motion "just for one effect." Pick one and stay there. Two animation libraries means two motion DNAs in the same UI — it always reads off.

## Rule 2 — Duration scale (no magic numbers)

Use named durations from a single scale. Put this in `lib/motion.ts`:

```ts
export const duration = {
  instant: 0.1,     // button press, micro-feedback
  quick:   0.2,     // hover transitions, small reveals
  normal:  0.35,    // most things — page reveals, modal open/close
  slow:    0.6,     // hero entrances, large reveals
  deliberate: 1.0,  // dramatic moments — use sparingly
}
```

- Under 0.1s → user perceives "instant" (no animation needed)
- Over 1.5s → feels broken, user thinks something's stuck
- Never use `duration: 0.4` or `duration: 0.5` ad hoc — pick from the scale

## Rule 3 — Easing tokens

Three easings cover 95% of UI:

```ts
export const ease = {
  out:    [0.16, 1, 0.3, 1],          // most entrances. Strong start, gentle settle.
  inOut:  [0.65, 0, 0.35, 1],         // state transitions (open/close, expand/collapse)
  spring: { type: "spring", stiffness: 300, damping: 30 }, // physical reactions, drag, gestures
}
```

- Never `linear` for UI motion (only acceptable for marquees, progress bars, infinite loops)
- Never Framer's default `[0.6, 0.01, -0.05, 0.95]` without thinking — it has a noticeable wobble
- Never `easeInOut` alone (Tailwind's default) — too mechanical

## Rule 4 — Stagger rules

Animating lists:

- Stagger increment: **0.05s – 0.1s** (smaller for short lists, larger for longer)
- Total stagger time: **never exceed 1s** for the whole list — user gets impatient
- Lists > 10 items: animate the **container**, not each child (cheaper, less chaotic)

```tsx
<motion.ul
  initial="hidden"
  animate="show"
  variants={{ show: { transition: { staggerChildren: 0.06 } } }}
>
  {items.map(i => <motion.li key={i.id} variants={item} />)}
</motion.ul>
```

## Rule 5 — Reduced-motion fallback (mandatory)

Every animated component must respect `prefers-reduced-motion`. Two approaches:

**Hook (preferred for Framer Motion):**
```tsx
import { useReducedMotion } from "framer-motion"

const reduce = useReducedMotion()
<motion.div
  initial={reduce ? false : { opacity: 0, y: 20 }}
  animate={{ opacity: 1, y: 0 }}
  transition={{ duration: reduce ? 0 : duration.normal, ease: ease.out }}
/>
```

**Global CSS fallback (for CSS animations and libraries that don't expose hooks):**
```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

Magic UI and Aceternity components rarely respect this out of the box — **wrap them yourself**, or accept that ~30% of users will silently suffer.

## Rule 6 — When NOT to animate

Animation costs attention. Skip it for:

- Form input focus rings — should be **instant**, not eased
- Data tables — animating row insertion looks fancy but breaks scanning
- Frequent interactions (toast that fires 50×/session shouldn't bounce each time)
- Above-the-fold critical content — delaying LCP for a fade-in is a real cost
- Loading spinners — they should just *be there* immediately, not fade in

Animate where motion adds **clarity**: state transitions, hierarchy reveals, hero entrances, scroll progression, draggable affordances.

## Rule 7 — Animation budget per viewport

**Maximum 2 simultaneously animated elements in viewport** at any time. Three or more = visual chaos.

Counted: hero text entrance, animated background, marquee, number ticker, scroll-triggered card reveal, looping decoration.
Not counted: hover states (only one active), micro-interactions on press.

If a section *needs* more, use scroll-pinning to reveal in sequence (`gpt-taste` ScrollTrigger pattern — one focal element at a time).

## Rule 8 — Common motion mistakes

- **Animating layout properties** (`width`, `height`, `top`, `left`) — use `transform` + `opacity`. Layout props trigger reflow on every frame.
- **Bouncy spring on dismiss** — feels wrong. Springs work for *entering*, eases work for *leaving*.
- **Same easing for in and out** — usually wrong. Things should ease out fast on dismiss (don't make users wait).
- **Forgetting `will-change`** — for transforms on large surfaces. Use `will-change: transform` on the animated element (and remove after animation if not looping).
- **Animating during scroll** — scroll-linked animations should use `requestAnimationFrame` or library scrubbing (Framer's `useScroll`, GSAP ScrollTrigger). Never bind to `onScroll` directly.

## Rule 9 — Coherence checklist (before reporting done)

- [ ] All entrances use `ease.out` from the scale
- [ ] All durations come from the named scale (search file for `duration: 0.` and verify)
- [ ] No mixed Framer Motion + GSAP in the same project
- [ ] No two adjacent components animate on the same scroll trigger (stagger or sequence them)
- [ ] Reduced-motion verified by toggling OS setting (macOS: System Settings → Accessibility → Display → Reduce motion)
- [ ] Mobile: animations don't cause jank on a mid-tier device (Chrome DevTools throttle to 4× CPU)
