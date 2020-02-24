#!/bin/bash

SRC=$(realpath $(dirname $0))
DEST=$HOME

try_ln() {
    local out
    local rc
    echo "  $(basename $1)"
    out=$(ln -sn "$1" "$2" 2>&1)
    rc=$?
    if [ $rc -ne 0 ]; then
        [ -f "$2" ] || [ -d "$2" ] && echo "    Already exists" || echo "    $out"
    fi
}

link_config() {
    local src
    local dest
    src="$SRC/$1"
    dest="$DEST/.$1"
    try_ln "$src" "$dest"
}

link_dir() {
    local dest
    local dir
    dest="$DEST/$2"

    echo "$1:"
    mkdir -p "$dest"

    dir=$(pwd)
    cd "$1"
    for file in *; do
        [ -f "$file" ] && try_ln "$SRC/$1/$file" "$dest/$file"
    done
    cd "$dir"
}

echo "Setting up symlinks from $SRC to $DEST"

echo "Configs:"
link_config bash_profile
link_config bashrc
link_config clang-format
link_config flake8
link_config gitconfig
link_config tmux.conf
link_config vimrc

link_dir bash .bash
link_dir bin bin
link_dir git bin/git
