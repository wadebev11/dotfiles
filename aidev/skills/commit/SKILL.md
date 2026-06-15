---
name: commit
description: Used when creating a git commit when committing working changes.
---

## Size of commits

Each commit should be quickly grokable by a human. This doesn't refer to the size of the commit, but more to the
complexity. Lint changes can include a lot of line changes, but not be difficult to understand. Each commit should be
able to stand alone as its own unit of logical work. A single commit shouldn't do multiple things. Those should be
broken out into their own commits.

## Purpose of commit messages

git commit messaages should communicate why something happened, not what happened. That's already stored in git. Don't
be overly verbose for simple changes. Default to concise commit messages, but if the reason for a specific change is
intricate, explain it thoroughly.

## Expected format

```
One line sentence explaining changes

Body of text explaining in more detail why certain things were done a
certain way. This shouldn't be a list of changes, git already does that
it should explain the why behind anything that might surprise the
reader.
```

Follow the 50/72 rule for line lengths in the commit message. 50 for the subject, 72 for the body

## Notes

- **DO NOT** add a co authored by line
