# Dotfiles

Scripts that configure a machine's shell, editor, and AI tooling from this repo, re-runnable without piling up duplicates.

## Language

**Managed block**:
The region of an rc file that `setup.sh` owns, fenced by a begin marker and an end marker. Everything outside it belongs to the user.

**Begin marker / End marker**:
The comment lines that fence a managed block. "Opening" and "closing" are used interchangeably with begin and end.

**Corrupt managed block**:
A managed block whose markers are unpaired, duplicated, or in the wrong order. `setup.sh` refuses to touch the file and leaves repair to the user.
