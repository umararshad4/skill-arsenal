# Quality Gate

The final checkpoint before reporting "done." Skipping this is how AI-generic UIs ship. Run every section every time, even for "small" changes.

## 1. Visual review (you cannot judge UI from code)

- [ ] Render in dev server at the actual ship viewport
- [ ] Take a screenshot
- [ ] Compare against a reference (Figma, the described design, or a best-in-class site in the same vertical: Linear, Vercel, Stripe, Arc, Raycast, Frame, Plaid)
- [ ] List what's wrong: spacing, type weight, color contrast, alignment, hierarchy
- [ ] Iterate. Top-notch is **3–5 passes minimum** — never accept first draft.

**Reject if** it looks like:
- A shadcn demo
- Every other Next.js landing page
- Vercel's template gallery
- A Tailwind tutorial

## 2. Accessibility check

- [ ] Tab through every interactive element. Focus visible? Tab order logical?
- [ ] Run axe: `npx @axe-core/cli http://localhost:3000` (or browser extension)
- [ ] Lighthouse accessibility score ≥ 95
- [ ] Contrast ratios: body text ≥ 4.5:1, large text ≥ 3:1 (use Chrome DevTools color picker)
- [ ] Every `<img>` has alt text (decorative = empty alt, meaningful = descriptive)
- [ ] Every interactive element has visible text OR `aria-label`
- [ ] No `outline: none` without a replacement focus style
- [ ] Forms: labels associated, errors announced (`aria-invalid`, `aria-describedby`), required fields marked
- [ ] Color is never the only signal (error = red text + icon + message, not just red)

## 3. Responsive sweep

Test in order. Stop and fix the first failure before continuing.

| Width | Device class | What to check |
|---|---|---|
| 375px | iPhone SE / older Android | No horizontal scroll. Touch targets ≥ 44×44px. Type readable without zoom. |
| 768px | iPad portrait | Breakpoint transitions clean. No awkward 2-col squeezes. |
| 1024px | iPad landscape / small laptop | Desktop layout begins. Hero text doesn't stretch full-width. |
| 1280px | Standard laptop | Default desktop. Container max-width respected. |
| 1920px | Large desktop / monitor | No "ocean of whitespace." Content scales or constrains gracefully. |

**Reject if**: text overflows containers, images stretch unnaturally, buttons go full-width on desktop, sections collapse onto each other on mobile, sticky elements obscure content.

## 4. Performance budget

**One-shot option**: `bash ~/.claude/skills/ui-arsenal/scripts/verify.sh [URL]` runs build + Lighthouse + axe and prints all numbers below. Quote the script output verbatim — don't eyeball.

Manual checks if the script isn't available:

Run `npm run build` and inspect:

- [ ] First Load JS per route ≤ 200KB (Next.js prints this — flag anything red)
- [ ] Total page weight (uncached) ≤ 1MB
- [ ] LCP ≤ 2.5s (Lighthouse)
- [ ] CLS ≤ 0.1
- [ ] INP ≤ 200ms
- [ ] Zero console errors in production build
- [ ] No hydration mismatches

If over budget, see [WORKFLOWS.md → Performance budget](WORKFLOWS.md) for remediation.

## 5. Motion & states

- [ ] All animations respect `prefers-reduced-motion` (see [MOTION.md](MOTION.md))
- [ ] Single motion-language across components (one easing family, one duration scale)
- [ ] Every async surface has explicit loading state (see [STATES.md](STATES.md))
- [ ] Every list/table has empty state with CTA
- [ ] Every form has inline field errors + top-level submit error path
- [ ] Every destructive action has confirmation OR undo

## 6. Final cosmetic pass — the AI-generic hunt

Common LLM-default tells. Find and kill:

- [ ] Every card has `shadow-md` → vary or remove
- [ ] Every section is `py-24` → introduce rhythm (16 / 24 / 32 / 48 / 64)
- [ ] All radii are `rounded-lg` → scale: sm inputs, md cards, xl/2xl hero blocks
- [ ] Inter + Geist with nothing else → add a display serif or distinctive sans
- [ ] Centered hero + subhead beneath → try left-aligned asymmetric, eyebrow stack, side-floated body
- [ ] `gray-500` for ALL secondary text → real hierarchy: foreground / muted / subtle
- [ ] Default browser focus ring → design a branded ring
- [ ] Lorem ipsum or "Lorem-flavored" copy ("Innovative solutions for modern teams") → real, specific copy

## 7. Report format

Tell the user:

- **Passed:** what works (one line per check group)
- **Borderline:** what's acceptable but could improve
- **Failed:** what blocks shipping and the specific fix

Never claim "done" while items in sections 1, 2, or 5 are unchecked. Sections 3, 4, 6 can be flagged borderline if pressed for time, but document the gap explicitly so the user knows what's outstanding.
