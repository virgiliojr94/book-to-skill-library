# Terminal agents on owned servers

## Core Idea

Coding agents running in persistent tmux sessions on owned VPS/servers via SSH are more powerful than isolated LLM apps because they modify live infrastructure.

## In his words

> "I think terminal based coding agents on the server are way more powerful than LLM apps because they can do actual stuff on your server like optimizing your Nginx config, speed up your SQLite db, or fix Ubuntu stuff like automatic upgrades."
> — [2026-08-06](https://x.com/levelsio/status/2085392337031581979)

> "Yes each of my sites is a Termius server with this kind of start command `cd /srv/http/hotelist.com && tm`. `tm` is a script made by Claude Code which puts it in a tmux session tied to the project name (from its folder). That means I always log back into my tmux session for each project!... Every tmux session has Claude Code open."
> — [2026-08-24](https://x.com/levelsio/status/2091987033367724309)

> "Very cool tip by @dhh to hook your Claude Code up to your Ubiquiti router and improve your WiFi!"
> — [2026-08-13](https://x.com/levelsio/status/2087903666158162214)

## What it says

The power of a coding agent is not in the text generation; it is in what the agent can do to a live system. An agent on a VPS can modify Nginx configs, tune SQLite, manage Ubuntu upgrades, adjust router WiFi settings. An LLM app in a browser cannot.

The practical infrastructure: tmux sessions tied to project directories, persistent across SSH disconnects, accessed via Termius. Each site lives on its own tmux session; each session has Claude Code open. Reconnect and continue where you left off.

## What changed

| When | Position |
|---|---|
| 2026-08-06 | States the principle: terminal agents > LLM apps |
| 2026-08-13 | Extends to network infrastructure (Ubiquiti router) |
| 2026-08-24 | Reveals operational workflow: tmux-per-project, Termius, `tm` script |

## Anti-patterns

- Treating terminal agents as equivalent to chat apps. The distinction is system access, not interface.
- Running agents on shared/cloud platforms where the agent cannot modify infrastructure.

## Connects To

- `safe-autonomy.md` — system access implies trust boundaries; reviewed PRs for production changes
- `own-data.md` — owned servers are where the data and the agents live