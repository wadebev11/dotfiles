#!/bin/bash

set -e

git config --global push.autoSetupRemote True
git config --global remote.origin.prune True
git config --global core.editor "vim"

echo "git configuration finished"

cat >> ~/.bashrc << EOF

# enable vim navigation of command line
set -o vi
EOF

echo "~/.bashrc updated"
