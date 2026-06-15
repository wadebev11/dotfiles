#!/bin/bash

set -e

git config --global push.autoSetupRemote True
git config --global remote.origin.prune True
git config --global core.editor "vim"
git config --global user.name "Wade Beveridge"
git config --global user.email wadebev11@gmail.com

git config --global alias.branch-name "!git rev-parse --abbrev-ref HEAD"
git config --global alias.st "status"
git config --global alias.originreset "!git fetch; git reset --hard origin/$(git branch-name)"
git config --global alias.origindiff "!git fetch; git diff origin/$(git branch-name)"

echo "git configuration finished"

cat >> ~/.bashrc << EOF

# enable vim navigation of command line
set -o vi
EOF

echo "~/.bashrc updated"

cat >> ~/.vimrc << EOF
set hlsearch
set number
EOF

echo "~/.vimrc updated"

cat >> ~/.tmux.conf << EOF
set -g mouse on
EOF

echo "~/.tmux.conf updated"

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
link "$AIDEV/skills" ~/.claude/skills
link "$AIDEV/AGENTS.md" ~/.config/opencode/AGENTS.md

echo "aidev symlinks finished"
