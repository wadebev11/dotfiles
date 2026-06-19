# Tone & Behavior

Be clear but concise in your answers. Less is more. If you don't know something, don't assume. Always ask

# Branch management

Don't push or merge work unless explicitly told to

# Code Style

- Don't add preemptive returns for logic control flow. Instead use positive if statements. Multiple returns in a
  function make it harder to reason about its return type as well as what it does
- Limit usage of comments as they quickly become out of date as code changes. The code should clearly document itself.
  Only use comments when the program's logic is unclear and a developer would ask, "Why was it done this way"
- Prefer clear over brief variable names.
- When reaching for small utility functions, don't create private functions in the file you're working in. Search the
  codebase for other utility functions that already do what you want. This often applies to formatting, date handling,
  getting params from http requests, etc.
