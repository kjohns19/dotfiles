#!/usr/bin/env python3.9

import argparse
import os
import pathlib


def main() -> None:
    args = parse_args()
    print(f'Installing to {args.directory}')

    root = pathlib.Path(__file__).parent.resolve()
    links = [
        (link, '.' + link)
        for link in [
            'ackrc',
            'bash_profile',
            'bashrc',
            'clang-format',
            'flake8',
            'gitconfig',
            'inputrc',
            'tmux.conf',
            'vimrc'
        ]
    ]
    for srcname, destname in links:
        make_link(root, root / srcname, args.directory / destname, dryrun=args.dryrun)

    dirs = [
        ('bash', '.bash'),
        ('bin', 'bin'),
        ('git/bin', 'bin/git'),
        ('git/hooks', '.git/hooks'),
        ('vim/ftplugin', '.vim/ftplugin'),
        ('vim/swapfiles', '.vim/swapfiles'),
        ('vim/after/syntax', '.vim/after/syntax'),
    ]
    for srcname, destname in dirs:
        make_dir(root, root / srcname, args.directory / destname, dryrun=args.dryrun)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()

    parser.add_argument(
        '--directory', '-d', type=pathlib.Path, default=pathlib.Path.home(),
        help='Install to this directory. '
             'By default this will be the user\'s home directory')

    parser.add_argument(
        '--dryrun', action='store_true',
        help='Don\'t actually install anything')

    args = parser.parse_args()
    return args


def make_dir(root: pathlib.Path, src: pathlib.Path, dest: pathlib.Path,
             dryrun: bool = False) -> None:
    print(f'{src.relative_to(root)} => {dest}')
    if (dest.is_symlink() or dest.exists()) and not dest.is_dir():
        backup(dest, dryrun=dryrun, indent=1)
    if not dryrun:
        dest.mkdir(parents=True, exist_ok=True)
    for f in src.glob('*'):
        if f.name != 'dummy':
            make_link(root, f, dest.joinpath(f.name), dryrun=dryrun, indent=1)


def make_link(root: pathlib.Path, src: pathlib.Path, dest: pathlib.Path,
              dryrun: bool = False, indent: int = 0) -> None:
    tabs = '  ' * indent
    print(f'{tabs}{src.relative_to(root)} => {dest}')
    directory = dest.parent
    if not dryrun:
        directory.mkdir(parents=True, exist_ok=True)
    if dest.is_symlink() or dest.exists():
        if dest.is_symlink() and os.readlink(dest) == str(src):
            return
        else:
            backup(dest, dryrun=dryrun, indent=indent+1)
    if not dryrun:
        dest.symlink_to(src)


def backup(dest: pathlib.Path, dryrun: bool = False, indent: int = 0) -> None:
    tabs = '  ' * indent
    bak = dest.with_name(dest.name + '.bak')
    if bak.is_symlink() or bak.exists():
        backup(bak, dryrun=dryrun, indent=indent)
    print(f'{tabs}Backing up {dest} to {bak}')
    if not dryrun:
        dest.rename(bak)


if __name__ == '__main__':
    main()
