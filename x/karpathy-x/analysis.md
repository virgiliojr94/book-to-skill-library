# Clustering report — @karpathy X corpus

Source: https://x.com/karpathy
Corpus: 368 authored posts (32 retweets excluded), 2024-06-09 → 2026-08-02
Every theme below is backed by verified post URLs from this window. Themes that
could not fill the template honestly were dropped (listed at the end).

---

## Theme: Vibe coding
Posts: 22 substantial across 2025-02 – 2026-04
Sources:
- https://x.com/karpathy/status/1886192184808149383 (2025-02-02, coinage)
- https://x.com/karpathy/status/1903671737780498883 (2025-03-23, iOS app)
- https://x.com/karpathy/status/1917961248031080455 (2025-05-01, MenuGen)

Claim: He coined "vibe coding" for the mode where you stop reading the diffs —
accept everything, paste errors back without comment, let the code grow past
your comprehension — and he scoped it from the start to throwaway weekend
projects, not to code you professionally care about.

Evolution: The February 2025 coinage is playful ("not too bad for throwaway
weekend projects"). By May 2025, having actually shipped MenuGen, he reports the
deployment half was "a painful slog" — the LLM handled the local demo, while he
spent most of his time in browser tabs wiring services, keys and configs. The
term's popular usage drifted toward "AI writes production code"; his own posts
never made that claim.

---

## Theme: The tight leash (AI-assisted coding, as distinct from vibe coding)
Posts: verified on the 2025-04-25 rhythm post, reinforced across the vibe-coding cluster
Sources:
- https://x.com/karpathy/status/1915581920022585597 (2025-04-25, the explicit loop)
- https://x.com/karpathy/status/1917961248031080455 (2025-05-01, what breaks without it)

Claim: For code he actually cares about, he runs a deliberate loop: stuff all
relevant context in; describe one concrete incremental change; **ask for
high-level approaches with pros/cons before asking for code**; pick one; request
a first draft; review against real API docs pulled up manually; test; commit;
then ask what to do next. Repeat.

His stated reason: the model is "an over-eager junior intern savant with
encyclopedic knowledge of software, but who also bullshits you all the time, has
an over-abundance of courage and shows little to no taste for good code." The
loop's emphasis is on being "slow, defensive, careful."

Decision rule: throwaway → vibe code; code you care about → tight leash. He
applies both, and the distinction is his, stated explicitly.

---

## Theme: Jagged Intelligence
Posts: 5 across 2024-07 – 2026-04
Sources:
- https://x.com/karpathy/status/1816531576228053133 (2024-07-25, coinage)

Claim: His coined term for the fact that SOTA models solve complex problems while
failing trivial ones — 9.11 vs 9.9, counting letters, tic-tac-toe — and "it's not
always obvious which is which." Unlike humans, where capabilities correlate and
improve together, model capability is spiky and uncorrelated.

He does not treat this as fundamental; he attributes it partly to a lack of
"cognitive self-knowledge" in the models.

Practical consequence: you cannot infer competence on task B from competence on
task A. Verification must be per-task.

---

## Theme: You're asking the data labeler, not "an AI"
Posts: 11 in the animals/ghosts cluster, 2024-11 – 2026-02
Sources:
- https://x.com/karpathy/status/1862565643436138619 (2024-11-29)

Claim: "You're not asking some magical AI. You're asking a human data labeler.
Whose average essence was lossily distilled into statistical token tumblers."
He offers caveats himself — labelers in code/math/creative writing are skilled
hires, and RL complicates the picture — but holds the frame as roughly true.

Use: an antidote to treating model output as oracular. The question isn't "what
does the AI know", it's "who wrote the data this was imitating."

---

## Theme: RLHF is just barely RL
Posts: 17 substantial across 2024-08 – 2026-04
Sources:
- https://x.com/karpathy/status/1821277264996352246 (2024-08-07, the full rant)

Claim: RLHF is not RL in the AlphaGo sense. Real RL optimizes against a ground-
truth reward (winning). RLHF optimizes against a reward model trained to imitate
a human "vibe check" — a lossy proxy that can be gamed. "RL is powerful. RLHF is
not."

His related position: actual RL remains constrained to domains with easy reward
functions (math etc.).

---

## Theme: Moravec's paradox in evals
Posts: part of the evals cluster, 21 substantial posts 2024-06 – 2026-06
Sources:
- https://x.com/karpathy/status/1855659091877937385 (2024-11-10)

Claim: Models are in "top expert territory" on benchmarks while you still
wouldn't hire them for menial jobs. They solve closed problems served neatly in
the prompt, but struggle to "coherently string together long, autonomous,
problem-solving sequences" that people find easy. Benchmark position and job
readiness are different axes.

---

## Theme: Code is liability; the core is small
Posts: 26 substantial across 2024-06 – 2026-08
Sources:
- https://x.com/karpathy/status/1803963383018066272 (2024-06-21, micrograd: "These 94 lines of code are everything that is needed to train a neural network. Everything else is just efficiency.")
- https://x.com/karpathy/status/1811140282559385758 (2024-07-10, "the if-then-else monster")

Claim: He repeatedly returns to minimal implementations as the thing that
actually teaches, and names configuration sprawl as a specific pathology:
"Bloated functions that take dozens of kwargs. When you read the code you can't
even tell what runs because the cross-product of all the configurations is
beyond human comprehension. Majority of the paths are deprecated, unsupported,
or unadvisable."

---

## Theme: Cognitive core / LLM personal computing
Posts: 2 substantial (2025-06, 2025-10) — reported as an observation, not a framework
Sources:
- https://x.com/karpathy/status/1938626382248149433 (2025-06-27)

Claim: He describes a "few billion param model that maximally sacrifices
encyclopedic knowledge for capability", always-on and local — trading world
knowledge for latency, privacy, offline continuity and sovereignty ("not your
weights not your brain").

Honest scope: only 2 posts in this window. Below the 3-post bar for a framework;
included as a labeled observation, not presented as established doctrine.

---

## Theme: Mixed autonomy / humans as supervisors
Posts: 16 in the autonomy cluster, 2024-08 – 2026-04
Sources:
- https://x.com/karpathy/status/1882544526033924438 (2025-01-23)

Claim: Computer-use agents are to the digital world what humanoid robots are to
the physical one — one general interface designed for humans, leading to "a
gradually mixed autonomy world, where humans become high-level supervisors of
low-level automation. A bit like a driver monitoring the Autopilot." He expects
this to arrive faster digitally because "flipping bits is ~1000X less expensive
than moving atoms", while noting he's "not 100% sure if it is ready."

---

## Dropped — did not meet the bar

- **March of nines**: 0 posts matched in this corpus window. The phrase is
  associated with him elsewhere (podcast), but is NOT in these posts. Excluded.
- **Autonomy slider**: 2 matches, both thin. Insufficient.
- **Decade of agents**: only reachable via the 2025-10-18 Dwarkesh post, which
  references the podcast rather than stating the framework. Not extractable
  from post text alone.
- **Education / Eureka Labs**: 25 posts, but they are announcements and course
  releases — activity, not transferable framework.

---

## Corpus limits

This window starts 2024-06-09. Earlier coinages (software 2.0, etc.) are outside
it. X's timeline pagination stops well short of a full archive; nothing here
should be read as "everything Karpathy thinks" — only as what he posted in this
window.
