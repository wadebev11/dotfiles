# opencode reads skills through the ~/.claude link, not its own skills symlink

`setup.sh` symlinks `aidev/AGENTS.md` and `aidev/skills` into `~/.claude`, but
for opencode it only symlinks `AGENTS.md` — deliberately **not**
`~/.config/opencode/skills`. opencode loads global skills additively from
`~/.config/opencode/skills`, `~/.claude/skills`, and `~/.agents/skills` with no
documented deduplication, so since opencode already discovers our skills via
the `~/.claude/skills` link, adding a second opencode-owned link to the same
`aidev/skills` directory would register every skill twice. `AGENTS.md` is safe
to link in both places because opencode reads its own `AGENTS.md` *or* falls
back to `~/.claude/CLAUDE.md` (either/or, never both), so there is no
duplication risk there.
