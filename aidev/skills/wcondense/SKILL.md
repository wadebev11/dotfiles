---
name: wcondense
description:
  Cuts a piece of writing to what its reader needs to act, then reports what was removed so the developer can
  veto a cut.
argument-hint: the text, a file path, or "last response"
---

The piece says too much. Cut it to what changes what the reader does; everything else is noise, however true.

1. Name the reader and what they will do with the piece. A sentence earns its place only if the reader would act
   differently without it. True and relevant is not enough.
2. Assume a competent reader. Drop anything they would do or infer anyway from the purpose, the surrounding
   text, or the domain: rationale they already share, examples of a rule they would apply correctly without
   one, restatement, summaries, explanations of commands they know, sections that mirror the process already
   given.
3. Keep verbatim: the author's terminology, code, commands, paths, quoted error text, and any constraint or
   non-obvious "why" the reader would get wrong without it. If the piece is wrong, condense it as is and note
   it.
4. Expect to remove at least a third. If less came out, you were preserving sentences, not behavior; go again.
5. A file is edited in place; anything else is returned in a fenced block. Follow with the word counts and one
   line per removed claim the developer might want back. Cuts are cheap to reverse from that list.
