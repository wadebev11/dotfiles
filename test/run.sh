#!/bin/bash

set -u

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$DOTFILES/lib.sh"

for git_config_override in GIT_CONFIG_GLOBAL XDG_CONFIG_HOME; do
  if [ -n "${!git_config_override:-}" ]; then
    echo "error: $git_config_override is set, so git would write global config outside the throwaway HOME; unset it and re-run" >&2
    exit 1
  fi
done

assert_eq() {
  actual="$1"
  expected="$2"
  if [ "$actual" != "$expected" ]; then
    diff <(echo "$expected") <(echo "$actual") | sed 's/^/    /'
    return 1
  fi
}

assert_contains() {
  haystack="$1"
  needle="$2"
  if [[ "$haystack" != *"$needle"* ]]; then
    echo "    expected to contain: $needle"
    echo "    actual: $haystack"
    return 1
  fi
}

DOTFILES_BEGIN='# >>> dotfiles managed block >>>'
DOTFILES_END='# <<< dotfiles managed block <<<'

test_write_block_creates_missing_file_with_block() {
  echo 'set -o vi' | write_block "$HOME/.bashrc" '#' > /dev/null
  assert_eq "$(cat "$HOME/.bashrc")" "$DOTFILES_BEGIN
set -o vi
$DOTFILES_END"
}

test_write_block_creates_missing_parent_directory() {
  echo 'GLOSSARY.md' | write_block "$HOME/.config/git/ignore" '#' > /dev/null
  assert_eq "$(cat "$HOME/.config/git/ignore")" "$DOTFILES_BEGIN
GLOSSARY.md
$DOTFILES_END"
}

test_write_block_appends_block_to_existing_content() {
  printf 'existing line\n' > "$HOME/.bashrc"
  echo 'set -o vi' | write_block "$HOME/.bashrc" '#' > /dev/null
  assert_eq "$(cat "$HOME/.bashrc")" "existing line
$DOTFILES_BEGIN
set -o vi
$DOTFILES_END"
}

test_write_block_replaces_block_in_place() {
  printf 'before\n%s\nold\n%s\nafter\n' "$DOTFILES_BEGIN" "$DOTFILES_END" > "$HOME/.bashrc"
  echo 'new' | write_block "$HOME/.bashrc" '#' > /dev/null
  assert_eq "$(cat "$HOME/.bashrc")" "before
$DOTFILES_BEGIN
new
$DOTFILES_END
after"
}

test_write_block_is_idempotent() {
  echo 'set -o vi' | write_block "$HOME/.bashrc" '#' > /dev/null
  first="$(cat "$HOME/.bashrc")"
  echo 'set -o vi' | write_block "$HOME/.bashrc" '#' > /dev/null
  assert_eq "$(cat "$HOME/.bashrc")" "$first"
}

test_write_block_uses_given_comment_prefix() {
  echo 'set number' | write_block "$HOME/.vimrc" '"' > /dev/null
  assert_eq "$(head -1 "$HOME/.vimrc")" '" >>> dotfiles managed block >>>'
}

test_write_block_matches_markers_with_trailing_whitespace() {
  printf '%s  \nold\n%s\t\n' "$DOTFILES_BEGIN" "$DOTFILES_END" > "$HOME/.bashrc"
  echo 'new' | write_block "$HOME/.bashrc" '#' > /dev/null
  assert_eq "$(cat "$HOME/.bashrc")" "$DOTFILES_BEGIN
new
$DOTFILES_END"
}

test_write_block_refuses_duplicate_begin_markers() {
  printf '%s\n%s\n%s\n' "$DOTFILES_BEGIN" "$DOTFILES_BEGIN" "$DOTFILES_END" > "$HOME/.bashrc"
  original="$(cat "$HOME/.bashrc")"
  status=0
  output="$(echo 'new' | write_block "$HOME/.bashrc" '#' 2>&1)" || status=$?
  assert_eq "$status" 1
  assert_contains "$output" "corrupt managed block (2 begin markers, 1 end markers)"
  assert_eq "$(cat "$HOME/.bashrc")" "$original"
}

test_write_block_refuses_missing_end_marker() {
  printf '%s\nold\n' "$DOTFILES_BEGIN" > "$HOME/.bashrc"
  original="$(cat "$HOME/.bashrc")"
  status=0
  output="$(echo 'new' | write_block "$HOME/.bashrc" '#' 2>&1)" || status=$?
  assert_eq "$status" 1
  assert_contains "$output" "corrupt managed block (1 begin markers, 0 end markers)"
  assert_eq "$(cat "$HOME/.bashrc")" "$original"
}

test_write_block_refuses_end_marker_before_begin_marker() {
  printf '%s\nold\n%s\n' "$DOTFILES_END" "$DOTFILES_BEGIN" > "$HOME/.bashrc"
  original="$(cat "$HOME/.bashrc")"
  status=0
  output="$(echo 'new' | write_block "$HOME/.bashrc" '#' 2>&1)" || status=$?
  assert_eq "$status" 1
  assert_contains "$output" "end marker on line 1 comes before begin marker on line 3"
  assert_eq "$(cat "$HOME/.bashrc")" "$original"
}

test_link_dotfile_creates_symlink_and_parent_directory() {
  touch "$HOME/target"
  link_dotfile "$HOME/target" "$HOME/.config/nested/link" > /dev/null
  assert_eq "$(readlink "$HOME/.config/nested/link")" "$HOME/target"
}

test_link_dotfile_leaves_correct_symlink_alone() {
  touch "$HOME/target"
  ln -s "$HOME/target" "$HOME/link"
  output="$(link_dotfile "$HOME/target" "$HOME/link")"
  assert_eq "$output" "ok: $HOME/link -> $HOME/target"
  [ ! -e "$HOME/link.bak" ]
}

test_link_dotfile_backs_up_existing_regular_file() {
  touch "$HOME/target"
  echo 'user content' > "$HOME/link"
  link_dotfile "$HOME/target" "$HOME/link" > /dev/null
  assert_eq "$(readlink "$HOME/link")" "$HOME/target"
  assert_eq "$(cat "$HOME/link.bak")" "user content"
}

test_link_dotfile_replaces_symlink_pointing_elsewhere() {
  touch "$HOME/target" "$HOME/other"
  ln -s "$HOME/other" "$HOME/link"
  link_dotfile "$HOME/target" "$HOME/link" > /dev/null
  assert_eq "$(readlink "$HOME/link")" "$HOME/target"
  assert_eq "$(readlink "$HOME/link.bak")" "$HOME/other"
}

test_setup_runs_from_another_directory() {
  mkdir "$HOME/elsewhere"
  cd "$HOME/elsewhere"
  "$DOTFILES/setup.sh" > /dev/null
  assert_eq "$(git config --global user.name)" "Wade Beveridge"
  assert_eq "$(readlink "$HOME/.claude/CLAUDE.md")" "$DOTFILES/aidev/AGENTS.md"
  assert_eq "$(readlink "$HOME/.claude/skills/wcommit")" "$DOTFILES/aidev/skills/wcommit"
  assert_contains "$(cat "$HOME/.bashrc")" "set -o vi"
}

failures=0
for test_name in $(declare -F | awk '$3 ~ /^test_/ { print $3 }'); do
  (
    set -e
    HOME="$(mktemp -d)"
    export HOME
    trap 'rm -rf "$HOME"' EXIT
    "$test_name"
  )
  if [ $? -eq 0 ]; then
    echo "ok: $test_name"
  else
    echo "FAIL: $test_name"
    failures=$((failures + 1))
  fi
done

echo
if [ "$failures" -eq 0 ]; then
  echo "all tests passed"
else
  echo "$failures test(s) failed"
fi
exit "$failures"
