---
name: wpickup
description:
  Reads the handoff prompt written by whandoff at /tmp/whandoff and picks up the task as if it were freshly asked.
  Use to resume work handed off from a previous conversation.
---

## Purpose

Continue work that was packaged up by `whandoff` in an earlier conversation. Treat the content of `/tmp/whandoff`
exactly as if the developer had just typed it as their message — same investigation, same judgment calls, same
willingness to ask before implementing.

## Process

1. Read `/tmp/whandoff`.
2. Treat its content as the task at hand. Investigate first — read the files and lines it points to, confirm the
   mechanism it describes still holds.
3. Work it like any normal task: if there's a genuine design decision or more than one reasonable approach, present
   the options and wait for a choice before editing code. If the ask is unambiguous, proceed.

## Notes

- No staleness or provenance checks — the file is meant to be read and acted on immediately after `whandoff` writes
  it, not to persist.
- If `/tmp/whandoff` doesn't exist or is empty, say so rather than guessing what the task was.
