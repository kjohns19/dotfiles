#!/usr/bin/env bash

set -e

typeset -r SCRIPT_DIR=$(dirname "$0")
typeset -r PYTHON=python3.12

typeset -r -a DEPENDENCIES=(
    ack
    clang-format-18
    cmake
    g++
    gcc
    git
    $PYTHON
    $PYTHON-venv
    tmux
    vim-gtk3
)

typeset -a PYTHON_DEPENDENCIES=(
    black
    flake8
    isort
    mypy
    pylint
)

install_dependencies() {
    echo "Installing dependencies"
    sudo apt install "${DEPENDENCIES[@]}"
}

install_python_tools() {
    echo "Installing Python tools"
    typeset -r venv_dir="$SCRIPT_DIR/venv"
    if ! [[ -d "$venv_dir" ]]; then
        $PYTHON -m venv "$venv_dir"
    fi
    . "$venv_dir/bin/activate"
    pip install --upgrade pip
    pip install --upgrade "${PYTHON_DEPENDENCIES[@]}"
    deactivate
}

apply_patches() {
    typeset patch output rc
    for patch in $SCRIPT_DIR/patches/*; do
        echo "Applying patch: $patch"
        # patch returns non-zero if it skipped an already-applied patch
        # so if it does return non-zero, we need to check whether it was because of a skipped patch
        # or a different issue
        set +e
        output=$(sudo "$patch" 2>&1)
        rc=$?
        set -e
        echo "$output"
        if [[ "$rc" -ne 0 ]] && ! echo "$output" | grep 'Skipping patch' -q; then
            return "$rc"
        fi
    done
}

install_dotfiles() {
    echo "Installing dotfiles"
    $SCRIPT_DIR/install.py
}

install_vim_plugins() {
    echo "Installing vim plugins"
    typeset -r vundle_dir=~/.vim/bundle/Vundle.vim
    if ! [[ -d "$vundle_dir" ]]; then
        git clone https://github.com/VundleVim/Vundle.vim.git "$vundle_dir"
    else
        cd "$vundle_dir"
        git pull
    fi
    vim --clean '+source ~/.vimrc' +PluginUpdate +qall
}

cd "$SCRIPT_DIR"

install_dependencies
install_python_tools
apply_patches
install_dotfiles
install_vim_plugins
