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

## Layout

- `setup.sh` runs the setup end to end.
- `lib.sh` holds the functions `setup.sh` uses, kept separate so tests can source them without side effects.
- `test/run.sh` is the test suite.
- `aidev/` holds the agent instructions and skills that get symlinked into place.
- `GLOSSARY.md` defines the terms used in the scripts.
