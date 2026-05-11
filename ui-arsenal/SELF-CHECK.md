# Self-Check — Pre-Completion Ritual

**MANDATORY.** Before reporting "done" on any UI work, run through this exactly. Skipping it is the single biggest reason work ships AI-generic.

This is a **forcing function** — you must produce explicit answers in your response to each step. "I think it's fine" is not an answer. "It renders" is not an answer. Quote numbers and specific observations.

---

## Step 1 — Did I actually render it?

In your reply, fill these out verbatim:

```
Dev server URL loaded:        ________
Page rendered without errors: Y / N
One-line description of view: ________
Viewport tested:              ____ × ____ px
```

**Fail condition**: Can't answer → start dev server now (`npm run dev`) and render.

---

## Step 2 — Did I compare against a reference?

```
Reference URL compared against:                    ________
Three specific things the reference does well:     ________
Three specific things mine does differently:       ________ (better / worse / different)
```

**Fail condition**: Skipped → pick from [REFERENCE-VAULT.md](REFERENCE-VAULT.md) for the surface type and compare now.

---

## Step 3 — AI-generic regression scan

For each tell from [SKILL.md → Anti-patterns](SKILL.md), answer present / absent in current code:

```
shadow-md blanket on cards?                       present / absent
Every section uses py-24?                         present / absent
rounded-lg everywhere with no scale?              present / absent
Only neutral sans (Inter, Geist, system-ui)?      present / absent
text-gray-500 for all secondary text?             present / absent
Centered hero with subhead directly beneath?      present / absent
Three-equal-column pricing?                       present / absent
Same CTA visual weight everywhere?                present / absent
Lorem ipsum or generic marketing-speak copy?      present / absent
Default browser focus ring (no override)?         present / absent
Stock-photo people on white backgrounds?          present / absent
```

**Fail condition**: Any `present` → revise before claiming done.

---

## Step 4 — Taste-rule audit (numeric)

Cross-check against [TASTE-RULES.md](TASTE-RULES.md). State actual values used:

```
Hero headline size (desktop):           ____ px   (rule: ≥ 56, ideal 64–96)
Hero headline line-height:              ____      (rule: 0.9–1.05)
Hero headline letter-spacing:           ____      (rule: −0.02 to −0.04em)
Body text size (marketing):             ____ px   (rule: 17–20)
Body text line-height:                  ____      (rule: 1.5–1.7)
Body text max-width:                    ____ ch   (rule: 60–75)
Section vertical padding (desktop):     ____ px   (rule: ≥ 96)
Number of distinct radii used:          ____      (rule: ≥ 3 from scale)
Text color hierarchy levels:            ____      (rule: ≥ 3)
Distinct fonts in use:                  ____      (rule: 2 — display + body)
Primary brand colors in palette:        ____      (rule: 1 primary + 1 accent + neutrals)
Body text contrast ratio:               ____ :1   (rule: ≥ 7:1 for premium)
```

**Fail condition**: Any value out of spec → fix or explicitly justify the deviation in writing.

---

## Step 5 — Quality gate (numeric, via script)

Run the verification script and quote the actual output:

```bash
bash ~/.claude/skills/ui-arsenal/scripts/verify.sh http://localhost:3000
```

```
Lighthouse Performance:    ____ / 100   (must be ≥ 90)
Lighthouse Accessibility:  ____ / 100   (must be ≥ 95)
LCP:                       ____         (must be ≤ 2.5s)
CLS:                       ____         (must be ≤ 0.1)
First Load JS (route):     ____ KB      (must be ≤ 200)
axe violations:            ____         (must be 0)
```

**Fail condition**: Any threshold missed → fix or explicitly flag as a blocker. Do not silently ship.

If the script fails to run (Chrome missing, server not started, etc.), say so explicitly and run the manual equivalents from [QUALITY-GATE.md](QUALITY-GATE.md).

---

## Step 6 — Token discipline

Run the token scanner and confirm components use discovered tokens only:

```bash
bash ~/.claude/skills/ui-arsenal/scripts/scan-tokens.sh
```

```
[ ] My component uses only tokens from scan output
[ ] No hardcoded hex colors (#3b82f6 etc.) outside theme
[ ] No hardcoded font families (font-['Inter'] etc.)
[ ] No magic spacing numbers (mt-[37px] etc.)
```

**Fail condition**: Any unchecked → refactor to use tokens.

---

## Step 7 — States coverage

If the surface is async or interactive (cross-reference [STATES.md](STATES.md)):

```
[ ] Loading state matches real layout structure (skeleton mirrors content)
[ ] Empty state has illustration/icon + headline + body + CTA
[ ] Error state has clear message + recovery path
[ ] Success state has feedback (toast OR inline confirmation)
[ ] Optimistic updates for low-risk actions (toggles, reactions)
```

**Fail condition**: Async surface missing any of the four states → not done.

---

## Step 8 — Motion coverage

If the surface has motion (cross-reference [MOTION.md](MOTION.md)):

```
[ ] All animations use easing from the named scale (no Framer default)
[ ] All durations use the named scale (no 0.4, 0.5 ad hoc)
[ ] One motion library only (no Framer + GSAP mix)
[ ] prefers-reduced-motion respected (verified by toggling OS setting)
[ ] Max 2 simultaneously animated elements per viewport
```

**Fail condition**: Any mismatch → fix.

---

## Step 9 — Responsive sweep

Test at minimum these widths (cross-reference [QUALITY-GATE.md → Responsive](QUALITY-GATE.md)):

```
375px  (mobile):     no horizontal scroll, touch targets ≥ 44px, type readable
768px  (tablet):     layout transitions clean, no 2-col squeeze
1280px (laptop):     desktop default, container max-width respected
1920px (large):      no ocean of whitespace, content scales gracefully
```

State what you observed at each width. "I assumed it would work" is not an observation.

---

## Step 10 — Honest self-score

Score the work 1–10 on each dimension:

```
Visual polish (looks premium, not generic):     ____ / 10
Originality (would a Linear designer ship it?): ____ / 10
Accessibility (a11y verified, not assumed):     ____ / 10
Performance (numbers from Step 5):              ____ / 10
Cohesion (motion + type + color + layout sing): ____ / 10

Average: ____ / 10
```

**Threshold to report "top-notch / done"**:
- Average **≥ 8.5** for top-tier claim
- Average **≥ 7** for "shipping-quality"
- Below 7: list specifically what's holding back the score and propose fixes

---

## Step 11 — The honesty test

Ask yourself: would a senior designer at Linear / Vercel / Stripe / Frame / Anthropic actually ship this on their public site?

If you hesitate, the answer is no. Iterate.

---

## Output format when reporting to user

Your final message must include:

1. **Self-check summary** — status of all 11 steps (`done` / `failed` / `skipped because X`)
2. **Numeric checkpoints** — actual values from Step 4 and Step 5 (or explicit "didn't run because X")
3. **Honest score** — Step 10's average and the dimensions holding it back
4. **Next iteration plan** — if not at 9+/10, specific fixes that would push it there

### Do not say "done" while:
- Step 1 unanswered (never rendered)
- Step 5 unrun (no perf/a11y numbers)
- Step 7 incomplete (async surface missing states)
- Step 10 below threshold without explicit acknowledgement

---

## Why this exists

Every other doc in `ui-arsenal/` teaches what to *know*. This one enforces what to *do*. The skill can't have visual taste, but it can demand explicit accountability for every claim of quality.

Filling this in honestly takes 3–5 minutes. Skipping it costs the user a regression they have to find themselves later. Always run it.
