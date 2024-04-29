#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")

# Install dependencies
sudo apt install \
    ack \
    clang-format-18 \
    cmake \
    g++ \
    gcc \
    git \
    python3-pip \
    python3.12 \
    python3.12-venv \
    tmux \
    vim-gtk3 \
    --

# Install python tools
VENV_DIR="$SCRIPT_DIR/venv"
if ! [[ -d "$VENV_DIR" ]]; then
    python3.12 -m venv "$VENV_DIR"
fi
. "$VENV_DIR/bin/activate"
pip install \
    black \
    flake8 \
    mypy \
    --
deactivate

# Run install
$SCRIPT_DIR/install.py

# Install/update vim plugins
if ! [[ -d ~/.vim/bundle/Vundle.vim ]]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
vim --clean '+source ~/.vimrc' +PluginUpdate +qall
