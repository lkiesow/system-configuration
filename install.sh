#!/bin/bash

set -o nounset

cd "$(dirname "$0")"
CFGPATH="$(pwd)"

cd
set -o xtrace

ln -s "$CFGPATH/.zshrc" .
ln -s "$CFGPATH/.vim" .
ln -s "$CFGPATH/.vimrc" .
ln -s "$CFGPATH/.colors" .
ln -s "$CFGPATH/.gitconfig" .
