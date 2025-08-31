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
