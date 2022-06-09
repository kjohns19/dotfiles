#!/usr/bin/env python3.10

import argparse
import os
import pathlib


def main() -> None:
    args = parse_args()
    print(f'Installing to {args.directory}')

    root = pathlib.Path(__file__).parent.resolve()
    src_dest = [
        # Directories
        ('bash/',        '.bash/'),
        ('bin/',         'bin/'),
        ('git/',         '.git/'),
        ('vim/',         '.vim/'),
        # Files
        ('ackrc',        '.ackrc'),
        ('bash_profile', '.bash_profile'),
        ('bashrc',       '.bashrc'),
        ('clang-format', '.clang-format'),
        ('flake8',       '.flake8'),
        ('gitconfig',    '.gitconfig'),
        ('inputrc',      '.inputrc'),
        ('tmux.conf',    '.tmux.conf'),
        ('vimrc',        '.vimrc'),
    ]
    for srcname, destname in src_dest:
        install(root, root / srcname, args.directory / destname, dryrun=args.dryrun)


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


def install(root: pathlib.Path, src: pathlib.Path, dest: pathlib.Path,
            dryrun: bool = False, indent: int = 0) -> None:
    tabs = '  ' * indent
    print(f'{tabs}{src.relative_to(root)} => {dest}')
    is_dir = src.is_dir()

    # Check if dest already exists
    if (dest.is_symlink() or dest.exists()):
        # if src is a directory, backup dest if it isn't a directory
        # if src is not a directory, backup dest if it isn't a symlink to src
        if (is_dir and (dest.is_symlink() or not dest.is_dir())) or \
           (not is_dir and not (dest.is_symlink() and os.readlink(dest) == str(src))):
            backup(dest, dryrun=dryrun, indent=indent + 1)
        elif not is_dir:
            return

    # Create dest, as a new directory if src is a directory
    # or a symlink to src if src is a file
    if not dryrun:
        if is_dir:
            dest.mkdir(parents=True, exist_ok=True)
        else:
            dest.parent.mkdir(parents=True, exist_ok=True)
            dest.symlink_to(src)

    # Recursively install src contents if src is a directory
    if is_dir:
        for f in src.glob('*'):
            if f.name != 'dummy':
                install(root, f, dest / f.name, dryrun=dryrun, indent=indent + 1)


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
