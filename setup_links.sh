#!/bin/bash

DOTFILEDIR=$(realpath $(dirname $0))

echo "Setting up symlinks from $DOTFILEDIR to $HOME"

echo ".vimrc"
ln -sn "$DOTFILEDIR/vimrc" "$HOME/.vimrc"
echo ".bashrc"
ln -sn "$DOTFILEDIR/bashrc" "$HOME/.bashrc"
ln -sn "$DOTFILEDIR/bash" "$HOME/.bash"
echo ".tmux.conf"
ln -sn "$DOTFILEDIR/tmux.conf" "$HOME/.tmux.conf"
echo ".gitconfig"
ln -sn "$DOTFILEDIR/gitconfig" "$HOME/.gitconfig"
