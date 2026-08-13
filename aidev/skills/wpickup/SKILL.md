---
name: wpickup
description:
  Reads the handoff prompt written by whandoff at /tmp/whandoff and picks up the task as if it were freshly asked.
  Use to resume work handed off from a previous conversation.
---

## Purpose

Continue work that was packaged up by `whandoff` in an earlier conversation.

## Process

1. Read `/tmp/whandoff`.
2. Ask the user what to do next

## Notes

- If `/tmp/whandoff` doesn't exist or is empty, say so rather than guessing what the task was.
