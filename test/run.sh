#!/bin/bash

set -u

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib.sh"

assert_eq() {
  actual="$1"
  expected="$2"
  message="$3"
  if [ "$actual" != "$expected" ]; then
    echo "  assertion failed: $message"
    diff <(echo "$expected") <(echo "$actual") | sed 's/^/    /'
    return 1
  fi
}

assert_contains() {
  haystack="$1"
  needle="$2"
  message="$3"
  if [[ "$haystack" != *"$needle"* ]]; then
    echo "  assertion failed: $message"
    echo "    expected to contain: $needle"
    echo "    actual: $haystack"
    return 1
  fi
}

BEGIN='# >>> dotfiles managed block >>>'
END='# <<< dotfiles managed block <<<'

test_write_block_creates_missing_file_with_block() {
  echo 'set -o vi' | write_block "$HOME/.bashrc" '#' > /dev/null
  assert_eq "$(cat "$HOME/.bashrc")" "$BEGIN
set -o vi
$END" "new file contains only the managed block"
}

test_write_block_appends_block_to_existing_content() {
  printf 'existing line\n' > "$HOME/.bashrc"
  echo 'set -o vi' | write_block "$HOME/.bashrc" '#' > /dev/null
  assert_eq "$(cat "$HOME/.bashrc")" "existing line
$BEGIN
set -o vi
$END" "block is appended after user content"
}

test_write_block_replaces_block_in_place() {
  printf 'before\n%s\nold\n%s\nafter\n' "$BEGIN" "$END" > "$HOME/.bashrc"
  echo 'new' | write_block "$HOME/.bashrc" '#' > /dev/null
  assert_eq "$(cat "$HOME/.bashrc")" "before
$BEGIN
new
$END
after" "surrounding user content is preserved"
}

test_write_block_is_idempotent() {
  echo 'set -o vi' | write_block "$HOME/.bashrc" '#' > /dev/null
  first="$(cat "$HOME/.bashrc")"
  echo 'set -o vi' | write_block "$HOME/.bashrc" '#' > /dev/null
  assert_eq "$(cat "$HOME/.bashrc")" "$first" "running twice does not change the file"
}

test_write_block_uses_given_comment_prefix() {
  echo 'set number' | write_block "$HOME/.vimrc" '"' > /dev/null
  assert_eq "$(head -1 "$HOME/.vimrc")" '" >>> dotfiles managed block >>>' "vimrc begin marker uses a double quote"
}

test_write_block_matches_markers_with_trailing_whitespace() {
  printf '%s  \nold\n%s\t\n' "$BEGIN" "$END" > "$HOME/.bashrc"
  echo 'new' | write_block "$HOME/.bashrc" '#' > /dev/null
  assert_eq "$(cat "$HOME/.bashrc")" "$BEGIN
new
$END" "markers with trailing whitespace are still replaced"
}

test_write_block_refuses_duplicate_begin_markers() {
  printf '%s\n%s\n%s\n' "$BEGIN" "$BEGIN" "$END" > "$HOME/.bashrc"
  original="$(cat "$HOME/.bashrc")"
  status=0
  output="$(echo 'new' | write_block "$HOME/.bashrc" '#' 2>&1)" || status=$?
  assert_eq "$status" 1 "exit status is 1"
  assert_contains "$output" "corrupt managed block (2 begin markers, 1 end markers)" "error names the marker counts"
  assert_eq "$(cat "$HOME/.bashrc")" "$original" "file is left untouched"
}

test_write_block_refuses_missing_end_marker() {
  printf '%s\nold\n' "$BEGIN" > "$HOME/.bashrc"
  original="$(cat "$HOME/.bashrc")"
  status=0
  output="$(echo 'new' | write_block "$HOME/.bashrc" '#' 2>&1)" || status=$?
  assert_eq "$status" 1 "exit status is 1"
  assert_contains "$output" "corrupt managed block (1 begin markers, 0 end markers)" "error names the marker counts"
  assert_eq "$(cat "$HOME/.bashrc")" "$original" "file is left untouched"
}

test_write_block_refuses_end_marker_before_begin_marker() {
  printf '%s\nold\n%s\n' "$END" "$BEGIN" > "$HOME/.bashrc"
  original="$(cat "$HOME/.bashrc")"
  status=0
  output="$(echo 'new' | write_block "$HOME/.bashrc" '#' 2>&1)" || status=$?
  assert_eq "$status" 1 "exit status is 1"
  assert_contains "$output" "end marker on line 1 comes before begin marker on line 3" "error names the line numbers"
  assert_eq "$(cat "$HOME/.bashrc")" "$original" "file is left untouched"
}

test_link_dotfile_creates_symlink_and_parent_directory() {
  touch "$HOME/target"
  link_dotfile "$HOME/target" "$HOME/.config/nested/link" > /dev/null
  assert_eq "$(readlink "$HOME/.config/nested/link")" "$HOME/target" "symlink points at target"
}

test_link_dotfile_leaves_correct_symlink_alone() {
  touch "$HOME/target"
  ln -s "$HOME/target" "$HOME/link"
  output="$(link_dotfile "$HOME/target" "$HOME/link")"
  assert_eq "$output" "ok: $HOME/link -> $HOME/target" "reports the link as already correct"
  [ ! -e "$HOME/link.bak" ] || { echo "  assertion failed: no backup should be created"; return 1; }
}

test_link_dotfile_backs_up_existing_regular_file() {
  touch "$HOME/target"
  echo 'user content' > "$HOME/link"
  link_dotfile "$HOME/target" "$HOME/link" > /dev/null
  assert_eq "$(readlink "$HOME/link")" "$HOME/target" "symlink replaces the file"
  assert_eq "$(cat "$HOME/link.bak")" "user content" "original file is kept as .bak"
}

test_link_dotfile_replaces_symlink_pointing_elsewhere() {
  touch "$HOME/target" "$HOME/other"
  ln -s "$HOME/other" "$HOME/link"
  link_dotfile "$HOME/target" "$HOME/link" > /dev/null
  assert_eq "$(readlink "$HOME/link")" "$HOME/target" "symlink now points at target"
  assert_eq "$(readlink "$HOME/link.bak")" "$HOME/other" "old symlink is kept as .bak"
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
