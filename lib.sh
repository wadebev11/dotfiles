#!/bin/bash

write_block() {
  file="$1"
  comment_prefix="$2"
  block="$(cat)"
  begin_marker="$comment_prefix >>> dotfiles managed block >>>"
  end_marker="$comment_prefix <<< dotfiles managed block <<<"

  managed_block="$(printf '%s\n%s\n%s' "$begin_marker" "$block" "$end_marker")"

  touch "$file"
  updated_file="$(mktemp)"
  FILE="$file" MANAGED_BLOCK="$managed_block" BEGIN_MARKER="$begin_marker" END_MARKER="$end_marker" awk '
    { line = $0; sub(/[ \t\r]+$/, "", line) }
    line == ENVIRON["BEGIN_MARKER"] { begin_count++; begin_line = NR; print ENVIRON["MANAGED_BLOCK"]; inside_block = 1; next }
    line == ENVIRON["END_MARKER"] { end_count++; end_line = NR; inside_block = 0; next }
    !inside_block { print }
    END {
      if (begin_count != end_count || begin_count > 1) {
        printf "error: %s has a corrupt managed block (%d begin markers, %d end markers); repair it by hand and re-run\n", ENVIRON["FILE"], begin_count, end_count > "/dev/stderr"
        exit 1
      }
      if (begin_count == 1 && end_line < begin_line) {
        printf "error: %s has a corrupt managed block (end marker on line %d comes before begin marker on line %d); repair it by hand and re-run\n", ENVIRON["FILE"], end_line, begin_line > "/dev/stderr"
        exit 1
      }
      if (begin_count == 0) print ENVIRON["MANAGED_BLOCK"]
    }
  ' "$file" > "$updated_file"
  cat "$updated_file" > "$file"
  rm "$updated_file"

  echo "updated $file"
}

link() {
  target="$1"
  link_path="$2"

  mkdir -p "$(dirname "$link_path")"

  if [ -L "$link_path" ] && [ "$(readlink "$link_path")" = "$target" ]; then
    echo "ok: $link_path -> $target"
  else
    if [ -e "$link_path" ] || [ -L "$link_path" ]; then
      mv "$link_path" "$link_path.bak"
      echo "backed up existing $link_path -> $link_path.bak"
    fi
    ln -sfn "$target" "$link_path"
    echo "linked: $link_path -> $target"
  fi
}
