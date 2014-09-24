#!/bin/sh

CFGPATH=`dirname $0`

pushd ~ > /dev/null
ln -s $CFGPATH/.zshrc
ln -s $CFGPATH/.zshenv
ln -s $CFGPATH/.vim
ln -s $CFGPATH/.vimrc
ln -s $CFGPATH/.colors
ln -s $CFGPATH/.ctags
ln -s $CFGPATH/.gitconfig
popd > /dev/null
