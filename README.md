# Skill Arsenal

A growing collection of [Claude Agent SDK](https://docs.claude.com/en/api/agent-sdk) skills for serious frontend, design, and engineering work.

Each skill teaches Claude **how to think** about a specialized domain — what to fetch, what to prefer, what to avoid — so the agent stops producing generic output and starts behaving like a senior practitioner.

---

## What is a skill?

A skill is a folder containing a `SKILL.md` (and optional reference files) that gets loaded into Claude's context when the user's request matches its triggers. Anthropic introduced them as a way to extend Claude with domain knowledge without bloating the system prompt — they load **only when relevant**.

Skills live at one of two paths:

- `~/.claude/skills/<name>/` — personal, available across every project
- `<project>/.claude/skills/<name>/` — project-scoped, committed with the codebase

This repo is the **source of truth** for the skills; the installation step below symlinks them into one of those locations.

---

## Available skills

| Skill | Purpose | Stack |
|---|---|---|
| [`ui-arsenal`](./ui-arsenal/) | Premium component-library expert. Knows shadcn/ui, Radix, HeroUI, Magic UI, Aceternity, ReactBits, 21st.dev, Tailwind UI, Cult UI, Tremor, Recharts, TanStack Table. Decides which library to use, fetches live source, adapts to your theme, integrates cleanly. | React + Next.js + Tailwind |

*More skills coming — see [Roadmap](#roadmap).*

---

## Installation

### Install all skills (recommended)

Clone the repo somewhere stable, then symlink each skill into your personal Claude skills directory:

```bash
git clone https://github.com/umararshad4/skill-arsenal.git ~/skill-arsenal
mkdir -p ~/.claude/skills

# Symlink every skill in the repo
for skill in ~/skill-arsenal/*/; do
  name=$(basename "$skill")
  ln -sfn "$skill" "$HOME/.claude/skills/$name"
done

ls -la ~/.claude/skills/
```

Now any new skill added to the repo is one `git pull` away.

### Install a single skill

```bash
git clone https://github.com/umararshad4/skill-arsenal.git ~/skill-arsenal
ln -sfn ~/skill-arsenal/ui-arsenal ~/.claude/skills/ui-arsenal
```

### Verify

Open Claude Code in any project and check that the skill appears in the available-skills list. You should see `ui-arsenal` (or whichever you installed) with its description.

### Updating

```bash
cd ~/skill-arsenal && git pull
```

Symlinks point to the working copy, so updates are instant — no re-install needed.

---

## How to use `ui-arsenal`

The skill auto-loads when you ask Claude for anything that touches component-library work — for example:

- *"Add a pricing section to this landing page"*
- *"Build a hero with an animated background"*
- *"Which library should I use for charts?"*
- *"Pull a navbar from Aceternity"*
- *"Install a shadcn data table"*
- *"Find a top-tier marquee for this testimonials section"*

Once loaded, the skill:

1. Picks the right library from its decision matrix (shadcn for primitives, Magic UI for animation, Aceternity for hero showpieces, 21st.dev as the search layer, etc.)
2. Fetches the live component source from the official docs via WebFetch
3. Adapts the code to your project's Tailwind theme tokens (`bg-background` instead of `bg-white`, etc.)
4. Installs via the appropriate CLI (`npx shadcn@latest add ...`) or copy-paste flow
5. Hands off to a taste-skill (`soft-skill`, `brutalist-skill`, `minimalist-skill`, `gpt-taste`) for design polish

See [`ui-arsenal/SKILL.md`](./ui-arsenal/SKILL.md) for the full decision matrix and [`ui-arsenal/PATTERNS.md`](./ui-arsenal/PATTERNS.md) for composition recipes (hero, pricing, dashboard, data table, bento, etc.).

---

## Repo structure

```
skill-arsenal/
├── README.md              # This file
├── LICENSE                # MIT
└── ui-arsenal/            # First skill — premium component-library expert
    ├── SKILL.md           # Entry point: decision matrix + hard rules
    ├── LIBRARIES.md       # Registry of doc URLs, install commands, compatibility
    ├── WORKFLOWS.md       # Fetch → adapt → integrate process
    └── PATTERNS.md        # Composition recipes for common surfaces
```

Each skill is a self-contained folder. Adding a new one means dropping a new directory with at least a `SKILL.md` inside; the install loop in the [Installation](#installation) section picks it up automatically.

---

## Roadmap

Planned skills (subject to change):

- **api-arsenal** — Backend API design + framework expertise (tRPC, Hono, FastAPI, NestJS) with the same fetch/adapt/integrate pattern
- **db-arsenal** — Schema, migrations, query optimization across Postgres, Drizzle, Prisma, Supabase, Convex
- **auth-arsenal** — Auth patterns (Clerk, Better Auth, NextAuth, Supabase Auth) with security-first defaults
- **deploy-arsenal** — Deploy workflows (Vercel, Fly.io, Railway, Cloudflare Workers) with cost/perf trade-offs
- **content-arsenal** — Copywriting + microcopy for landing pages, error states, empty states, onboarding

Open an issue if you have a strong opinion on what should ship next.

---

## Contributing

This is a personal collection, but PRs are welcome — especially:

- Corrections to library URLs / install commands as they evolve
- New composition patterns
- Additional libraries worth knowing about

Open an issue first for anything larger than a one-line fix.

---

## Why "Arsenal"?

Because a top-tier engineer doesn't write everything from scratch — they have a curated arsenal of tools, libraries, and patterns ready to deploy. These skills encode that arsenal so Claude can deploy it on demand.

---

## License

[MIT](./LICENSE) — use, modify, redistribute freely. Attribution appreciated but not required.
