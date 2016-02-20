#!/bin/bash

DOTFILEDIR=$(realpath $(dirname $0))

echo "Setting up symlinks from $DOTFILEDIR to $HOME"

echo ".vimrc"
ln -s $DOTFILEDIR/vimrc ~/.vimrc
echo ".bashrc"
ln -s $DOTFILEDIR/bashrc ~/.bashrc
echo ".tmux.conf"
ln -s $DOTFILEDIR/tmux.conf ~/.tmux.conf
