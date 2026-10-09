# Vibe coding

## Core Idea

A mode of building where you stop supervising the code entirely. His coinage,
2025-02-02, and scoped by him to throwaway work in the same post that named it.

## In his words

> "There's a new kind of coding I call 'vibe coding', where you fully give in to
> the vibes, embrace exponentials, and forget that the code even exists. [...] I
> 'Accept All' always, I don't read the diffs anymore. When I get error messages
> I just copy paste them in with no comment, usually that fixes it. The code
> grows beyond my usual comprehension [...] Sometimes the LLMs can't fix a bug so
> I just work around it or ask for random changes until it goes away."
> — [2025-02-02](https://x.com/karpathy/status/1886192184808149383)

## The scope he attached

Same post, final line: **"It's not too bad for throwaway weekend projects, but
still quite amusing."** The limit was in the coinage, not added later.

He demonstrated the upside: a whole iOS app in Swift, a language he hadn't
programmed in, running on his physical phone ~1 hour later
([2025-03-23](https://x.com/karpathy/status/1903671737780498883)).

## What broke when he shipped one

MenuGen, a real deployed app with auth and payments
([2025-05-01](https://x.com/karpathy/status/1917961248031080455)):

> "Vibe coding menugen was exhilarating and fun escapade as a local demo, but a
> bit of a painful slog as a deployed, real app. [...] the LLMs have slightly
> outdated knowledge of everything, they make subtle but critical design
> mistakes when you watch them closely, and sometimes they hallucinate or
> gaslight you about solutions."

The notable detail: **the code editor wasn't the bottleneck.** He reports
spending most of the time in the browser — moving between tabs, services, keys,
configs. The LLM handled the demo; the integration surface stayed manual.

## Evolution

| When | Position |
|---|---|
| 2025-02 | Playful coinage, explicitly throwaway-only |
| 2025-03 | Genuine capability demo (iOS app, unfamiliar language) |
| 2025-05 | Local demo exhilarating; deployed app a "painful slog" |

The popular usage of the term drifted toward "AI writes production code." His
own posts in this window never made that claim.

## Anti-patterns

- Citing "vibe coding" as endorsement for production code. He scoped it against that.
- Assuming the demo→deployed gap is a prompting problem. He located it in services, docs, keys, configs.

## Connects To

- `tight-leash.md` — the deliberate opposite, for code that matters
