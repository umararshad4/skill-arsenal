# UI States

The four states that separate demo-grade from product-grade UI: **loading**, **empty**, **error**, **success**. Most AI-generated UIs ship only the happy path — that omission is the tell. Every async surface needs all four.

## Loading states

### Skeleton — preferred for content-heavy surfaces

Match the real layout. Block-level rectangles at the same dimensions as the real content, so there's no layout shift when content arrives.

```tsx
import { Skeleton } from "@/components/ui/skeleton"  // npx shadcn add skeleton

<div className="space-y-3">
  <Skeleton className="h-4 w-3/4" />
  <Skeleton className="h-4 w-1/2" />
  <Skeleton className="h-32 w-full rounded-lg" />
</div>
```

Rules:
- Skeleton structure **mirrors** the real layout — same heights, same gaps, same number of rows/cards. Otherwise content snaps in.
- Animate subtly. Tailwind's `animate-pulse` is fine; for premium feel use a shimmer keyframe (linear gradient sweeping left-to-right).
- Use for: tables, cards, lists, hero content, anything users wait > 200ms for.

### Spinner — only when content can't be skeleton-ed

For: form submissions in flight, button-triggered async, modal open while fetching.

```tsx
import { Loader2 } from "lucide-react"

<Button disabled={pending}>
  {pending && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
  {pending ? "Submitting..." : "Submit"}
</Button>
```

### Progress bar — for known-duration tasks

File uploads, multi-step wizards, video transcodes. Show **real** progress, never fake percentages.

### Anti-patterns

- Spinner for full-page content load — feels frozen. Always skeleton instead.
- "Please wait..." text — outdated. Skeleton communicates without words.
- Skeleton that doesn't match real layout — causes layout shift, feels broken.
- Spinner overlay that blocks the entire viewport — only acceptable for genuinely blocking operations (payment processing).

## Empty states

When a list, table, or section has zero items. The empty state is where you **teach** users what to do.

Structure (top to bottom):
1. **Visual** — subtle icon in a muted circle, OR a custom illustration. Never bug-eyed cartoons.
2. **Headline** — what's empty, in plain language ("No projects yet")
3. **Body** — one-line explanation ("Create your first project to get started")
4. **CTA** — the action that fills the void ("New project")

```tsx
<div className="flex flex-col items-center justify-center py-16 text-center">
  <div className="rounded-full bg-muted p-3 mb-4">
    <FolderIcon className="h-6 w-6 text-muted-foreground" />
  </div>
  <h3 className="text-lg font-semibold">No projects yet</h3>
  <p className="text-sm text-muted-foreground mt-1 mb-4 max-w-sm">
    Create your first project to start tracking work.
  </p>
  <Button>New project</Button>
</div>
```

### Variants

- **First-run empty** (user has never created data) — emphasize onboarding, show a tour link
- **Filtered empty** (user filtered to zero) — show "Clear filters" CTA, not "Create new"
- **Permission empty** (user can see the section but isn't allowed to act) — explain what they need

### Anti-patterns

- "No data" with nothing else — useless
- Generic stock illustration of a confused person — kills premium feel
- Empty state visually identical to loading state — users can't tell which is which
- "Coming soon" placeholder — ship the feature or hide the section

## Error states

Three scales — each gets a different treatment.

### Field-level (inline)

Directly below the input that caused it. Specific, actionable, not blaming.

```tsx
<FormMessage>
  Email must include an @ symbol
</FormMessage>
```

### Component-level (replaces content)

When a card / table / section fails to load. Preserves the rest of the page.

```tsx
<div className="rounded-lg border border-destructive/20 bg-destructive/5 p-6 text-center">
  <AlertCircle className="mx-auto h-6 w-6 text-destructive mb-2" />
  <p className="text-sm font-medium">Couldn't load projects</p>
  <p className="text-xs text-muted-foreground mt-1 mb-3">
    Check your connection and try again.
  </p>
  <Button size="sm" variant="outline" onClick={retry}>
    Retry
  </Button>
</div>
```

### Page-level (404, 500, full-page failure)

Use Next.js app router's `error.tsx` and `not-found.tsx` patterns. Include:
- What happened (vague but honest — "Something went wrong")
- What the user can do (retry button, link home, contact support)
- Never expose raw stack traces in production

### Error copy rules

- **Never** "An error occurred." — say what actually happened
- **Never** blame the user — "Email is required" not "You forgot the email"
- **Always** offer a recovery path — "Try again" / "Use a different card"
- **Distinguish** offline from server error from validation error — they have different fixes

## Success states

The most-forgotten state. After a successful action, what changes?

- **Form submit** → toast (`sonner`) + form clears + optional redirect, OR inline success message + reset
- **Save** → subtle confirmation (icon flip, brief "Saved" indicator, opacity fade on the "Save" button)
- **Delete** → toast with **Undo** action available for 5–10 seconds
- **Async commit** → optimistic update immediately, reconcile when server confirms

```tsx
import { toast } from "sonner"

toast.success("Project created", {
  description: "You can rename it any time.",
  action: { label: "Open", onClick: () => router.push(`/projects/${id}`) },
})
```

### Anti-patterns

- Alert dialog "Success!" — interrupts flow, feels old
- No feedback at all — user wonders if it worked, often clicks again
- Generic toast "Saved successfully" — never wrong, but never specific either ("Settings saved" beats "Saved successfully")

## Optimistic UI

For low-risk actions (like, follow, mark-as-read, reorder), update immediately. Reconcile when the server confirms.

```tsx
import { useOptimistic } from "react"

const [optimisticItems, addOptimistic] = useOptimistic(items, reducer)

async function action(formData: FormData) {
  addOptimistic(newItem)
  await serverAction(formData)
}
```

**Use for**: toggles, reactions, list reorders, mark-read, follow/unfollow.
**Don't use for**: payments, deletions, destructive actions, anything where silent rollback would confuse the user.

## State patterns by surface

Reference table — wire every async UI to these.

| Surface | Loading | Empty | Error | Success |
|---|---|---|---|---|
| Form | Spinner in submit button | n/a | `FormMessage` per field + top-level error if needed | Toast + clear + optional redirect |
| Data table | Skeleton rows (match column structure) | Illustration + headline + CTA OR "Clear filters" if filtered | Inline error block + retry button | (usually n/a) |
| Card list / grid | Skeleton cards (match real card size) | Empty illustration + primary CTA | Inline error per failed card OR section-level | (usually n/a) |
| Dashboard | Skeleton per card | Per-metric empty ("No data this period") | Per-card error + retry | (usually n/a) |
| Async button | Spinner + disabled | n/a | Toast `toast.error()` | Toast `toast.success()` |
| Modal/sheet | Skeleton body OR spinner if quick | Empty state inside | Inline error inside modal | Close modal + toast |
| File upload | Progress bar (real %) | n/a | Inline error + retry per file | Checkmark per file + toast |
| Search | Skeleton results | "No results for 'foo'" + suggestions | Inline error + retry | (usually n/a) |
| Hero | Image lazy-load only (no skeleton needed) | n/a | n/a | n/a |
| Marquee / logo cloud | None (static) | Hide if empty | n/a | n/a |

## Pre-flight (mirrors QUALITY-GATE.md section 5)

- [ ] Every async surface has a loading state matching real layout
- [ ] Every list/table renders correctly with 0 items
- [ ] Every form has inline field errors AND a top-level submit error path
- [ ] Every destructive action has confirmation OR undo
- [ ] Tested by toggling network offline in DevTools
- [ ] Tested by forcing API errors (mock 500 / 404 responses)
- [ ] No silent failures — every catch block surfaces something to the user
