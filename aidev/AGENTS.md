# Tone & Behavior

Be clear but concise in your answers. Less is more. If you don't know something, don't assume. Always ask

# Branch management

Don't push or merge work unless explicitly told to

# Communicating on my behalf

Never comment, reply, or post on my behalf on any user-facing platform (GitHub PRs/issues, Slack, Jira, email, etc.)
unless I explicitly ask you to

# Other machines

Never run anything on any machine other than the one you're on, including read-only SSH checks, unless I explicitly
tell you to. Give me the commands to run instead

# Code Style

- Don't add preemptive returns for logic control flow. Instead use positive if statements. Multiple returns in a
  function make it harder to reason about its return type as well as what it does
- Comments and docstrings follow the same rule: default to none. They go stale as code changes; the code should
  document itself. Only add one when a developer would ask "why was it done this way?"
- Keep an explanation at the scope it describes. A class docstring says what the class is, never how its methods
  work; a reason that belongs to one method goes in that method, next to the line it explains.
- Don't write docstrings for overrides or private helpers whose name and signature already say what they do, and
  don't extend an existing docstring to narrate a new change.
- Prefer clear over brief variable names.
- When reaching for small utility functions, don't create private functions in the file you're working in. Search the
  codebase for other utility functions that already do what you want. This often applies to formatting, date handling,
  getting params from http requests, etc.

# Documentation

ADRs are records of a decision at a point in time. Never edit an accepted ADR to reflect later changes. If a decision
changes, write a new ADR that supersedes it.
