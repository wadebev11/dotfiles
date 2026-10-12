# Dotfiles

Configures git, shell, editor, and AI tooling on a machine from this repo. Safe to re-run.

## Setup

```sh
./setup.sh
```

## Tests

```sh
./test/run.sh
```

Prints one line per test and exits nonzero if any fail. Tests run against a throwaway `HOME`, so they never touch your real dotfiles.

To add a test, define a function named `test_*` in `test/run.sh`. The runner discovers it automatically.

The suite also runs before every `git push` through `hooks/pre-push`. `setup.sh` points this repo's `core.hooksPath` at `hooks/`, so a fresh clone picks it up after one run of setup. To push anyway, use `git push --no-verify`.

## Layout

- `setup.sh` runs the setup end to end.
- `lib.sh` holds the functions `setup.sh` uses, kept separate so tests can source them without side effects.
- `test/run.sh` is the test suite.
- `hooks/` holds the git hooks for this repo.
- `aidev/` holds the agent instructions and skills that get symlinked into place.
- `GLOSSARY.md` defines the terms used in the scripts.
