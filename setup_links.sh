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
    dest="$DEST/$2"

    echo "$1:"
    mkdir -p "$dest"

    cd "$1"
    for file in *; do
        [ -f "$file" ] && try_ln "$SRC/$1/$file" "$dest/$file"
    done
}

echo "Setting up symlinks from $SRC to $DEST"

echo "Configs:"
link_config vimrc
link_config bashrc
link_config bash_profile
link_config gitconfig
link_config tmux.conf

link_dir bash .bash
