#!/bin/bash

set -e

git config --global push.autoSetupRemote True
git config --global remote.origin.prune True
git config --global core.editor "vim"
git config --global user.name "Wade Beveridge"
git config --global user.email wadebev11@gmail.com

git config --global alias.branch-name "!git rev-parse --abbrev-ref HEAD"
git config --global alias.st "status"
git config --global alias.branch-rename '!f() { old=$(git branch-name); git branch -m "$1" && git push -u origin "$1":"$1" && git push origin :"$old"; }; f'
git config --global alias.originreset '!git fetch; git reset --hard origin/$(git branch-name)'
git config --global alias.origindiff '!git fetch; git diff origin/$(git branch-name)'
git config --global alias.localprune '!git branch -v | grep "\[gone\]" | awk '\''{print $1}'\'' | xargs -r git branch -D'

echo "git configuration finished"

write_block() {
  file="$1"
  comment_prefix="$2"
  block="$(cat)"
  begin_marker="$comment_prefix >>> dotfiles managed block >>>"
  end_marker="$comment_prefix <<< dotfiles managed block <<<"

  managed_block="$(printf '%s\n%s\n%s' "$begin_marker" "$block" "$end_marker")"

  touch "$file"
  begin_lines="$(grep -nxF "$begin_marker" "$file" | cut -d: -f1)"
  end_lines="$(grep -nxF "$end_marker" "$file" | cut -d: -f1)"
  begin_count="$(printf '%s' "$begin_lines" | grep -c .)" || true
  end_count="$(printf '%s' "$end_lines" | grep -c .)" || true
  if [ "$begin_count" != "$end_count" ] || [ "$begin_count" -gt 1 ]; then
    echo "error: $file has a corrupt managed block ($begin_count begin markers, $end_count end markers); repair it by hand and re-run" >&2
    exit 1
  fi
  if [ "$begin_count" -eq 1 ] && [ "$end_lines" -lt "$begin_lines" ]; then
    echo "error: $file has a corrupt managed block (end marker on line $end_lines comes before begin marker on line $begin_lines); repair it by hand and re-run" >&2
    exit 1
  fi

  if [ "$begin_count" -eq 1 ]; then
    replaced="$(MANAGED_BLOCK="$managed_block" BEGIN_MARKER="$begin_marker" END_MARKER="$end_marker" awk '
      $0 == ENVIRON["BEGIN_MARKER"] { print ENVIRON["MANAGED_BLOCK"]; inside_block = 1 }
      $0 == ENVIRON["END_MARKER"] && inside_block { inside_block = 0; next }
      !inside_block { print }
    ' "$file")"
    printf '%s\n' "$replaced" > "$file"
  else
    printf '%s\n' "$managed_block" >> "$file"
  fi

  echo "updated $file"
}

write_block ~/.bashrc '#' << 'EOF'
# enable vim navigation of command line
set -o vi
alias xit=exit
EOF

write_block ~/.vimrc '"' << 'EOF'
set hlsearch
set number
set display=lastline
EOF

write_block ~/.tmux.conf '#' << 'EOF'
set -g mouse on
EOF

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AIDEV="$DOTFILES/aidev"

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

link "$AIDEV/AGENTS.md" ~/.claude/CLAUDE.md
link "$AIDEV/AGENTS.md" ~/.config/opencode/AGENTS.md

if [ -L ~/.claude/skills ]; then
  rm ~/.claude/skills
  echo "removed old whole-directory symlink at ~/.claude/skills"
fi
mkdir -p ~/.claude/skills
for skill_dir in "$AIDEV"/skills/*/; do
  skill_name="$(basename "$skill_dir")"
  link "$AIDEV/skills/$skill_name" ~/.claude/skills/"$skill_name"
done

echo "aidev symlinks finished"
