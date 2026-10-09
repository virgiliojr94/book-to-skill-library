---
name: karpathy-x
description: "Working patterns from @karpathy's X posts (2024-06 – 2026-08). Use when deciding how much to trust an LLM on a task, choosing between vibe coding and reviewed AI-assisted coding, reasoning about evals vs real-world capability, RLHF limits, jagged model behavior, or minimal-core code design."
---

<!-- argument-hint: [theme name, e.g. "vibe coding", "jagged intelligence", "leash"] -->

# Karpathy — X posts (2024-06 – 2026-08)

**Source**: 368 authored posts from https://x.com/karpathy | **Window**: 2024-06-09 → 2026-08-02 | **Generated**: 2026-08-26

Scope: this is what he posted in this window, not the whole of what he thinks.
Every claim below cites a post. Nothing here is inferred beyond the cited text.

## How to Use This Skill

- **No argument** — load the decision rules below
- **With a theme** — read the matching file in `chapters/`
- **Verifying a claim** — every framework carries permalinks; `corpus.md` holds all 368 posts with URLs

## Decision Rules

| Situation | Rule | Source |
|---|---|---|
| Throwaway weekend project | Vibe code it. Accept all, don't read diffs. | [2025-02-02](https://x.com/karpathy/status/1886192184808149383) |
| Code you professionally care about | Tight leash. Approaches before code, review against real docs, test, commit. | [2025-04-25](https://x.com/karpathy/status/1915581920022585597) |
| Model did well on task A | Infer nothing about task B. Capability is spiky. | [2024-07-25](https://x.com/karpathy/status/1816531576228053133) |
| Tempted to "ask the AI" | You're asking the average data labeler, lossily distilled. | [2024-11-29](https://x.com/karpathy/status/1862565643436138619) |
| Benchmark score looks superhuman | Doesn't transfer to long autonomous sequences. | [2024-11-10](https://x.com/karpathy/status/1855659091877937385) |
| Reaching for a config flag | The cross-product of configs exceeds comprehension. | [2024-07-10](https://x.com/karpathy/status/1811140282559385758) |

## Core Frameworks

**Vibe coding** — his coinage: give in to the vibes, forget the code exists, never
read diffs. Scoped by him to throwaway projects from day one. When he actually
shipped one (MenuGen), the deploy half was "a painful slog."
→ `chapters/vibe-coding.md`

**The tight leash** — the loop for code that matters. The model is "an over-eager
junior intern savant... who bullshits you all the time, has an over-abundance of
courage and shows little to no taste for good code."
→ `chapters/tight-leash.md`

**Jagged Intelligence** — his coinage: solves complex math, fails 9.11 vs 9.9.
"It's not always obvious which is which."
→ `chapters/jagged-intelligence.md`

**Asking the data labeler** — model output is imitation of human labelers, not oracle.
→ `chapters/data-labeler.md`

**RLHF is just barely RL** — real RL optimizes ground truth (winning); RLHF optimizes
a reward model imitating a human vibe check. "RL is powerful. RLHF is not."
→ `chapters/rlhf-barely-rl.md`

**Code is liability; the core is small** — "These 94 lines of code are everything that
is needed to train a neural network. Everything else is just efficiency."
→ `chapters/minimal-core.md`

**Mixed autonomy** — humans become "high-level supervisors of low-level automation.
A bit like a driver monitoring the Autopilot."
→ `chapters/mixed-autonomy.md`

## Observations (below framework bar)

- **Cognitive core** — a few-billion-param local model trading knowledge for
  sovereignty, "not your weights not your brain." Only 2 posts in window
  ([2025-06-27](https://x.com/karpathy/status/1938626382248149433)). Not doctrine.

## Not in this corpus

**March of nines** — 0 matches in these 368 posts. Associated with him elsewhere
(podcasts), but not extractable here. Do not attribute it to this source.

## Files

- `corpus.md` — all 368 posts, chronological, each with URL and date
- `analysis.md` — clustering report with post counts, spreads, and dropped themes
- `chapters/` — one file per framework
