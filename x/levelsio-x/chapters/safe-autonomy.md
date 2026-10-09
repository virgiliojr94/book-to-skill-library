# Safe autonomy via human-reviewed pull requests

## Core Idea

AI can safely prepare pull requests from bug reports and feature requests, but human review before merge is the current boundary. Automated intake remains unsafe due to prompt injection.

## In his words

> "Most of my work these days is copypasting all your bug reports or feature ideas into my clanker via Termius on my VPS."
> — [2026-08-24](https://x.com/levelsio/status/2091926355906597101)

> "I haven't directly connected my bug board to my AI because I am very aware of prompt injection risks. One safe way people mention would be to only give the AI access to collect user bug reports and feature requests, then do pull requests on GitHub that I then review myself before I approve or reject them... a benign attacker can prompt a feature request with an elaborate prompt that tells it to add a backdoor to your sites... Until that time I'll just keep manually reading bug reports and feature requests and copying them in Claude Code."
> — [2026-08-24](https://x.com/levelsio/status/2091960812004888655) (quote of @_tomas_dev, endorsing)

## What it says

The safe boundary: AI reads the bug/feature input, prepares a GitHub PR, human reviews and merges. The unsafe part: automated ingestion of user-submitted text into the agent, because prompt injection can cause the agent to insert hidden malicious changes that look like unrelated bug fixes.

Current practice: manual copy-paste from bug tracker to agent via Termius. The human acts as the injection filter.

## What changed

| When | Position |
|---|---|
| 2026-08-24 | Both posts on same day; no evolution within window |

## Anti-patterns

- Assuming prompt injection is a solved problem. The quoted post describes a concrete attack: hide a backdoor in a feature request, report it as "pagination fix" in the PR description.
- Automating the intake boundary before trust is established. "Until that time I'll just keep manually reading."

## Connects To

- `terminal-agents.md` — the agent has server access, so the injection boundary matters
- `own-data.md` — manual transfer keeps the human in the loop