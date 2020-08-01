#!/usr/bin/env python3.8

import argparse
import os
import pathlib


def main():
    args = parse_args()
    print(f'Installing to {args.directory}')

    root = pathlib.Path(__file__).parent.resolve()
    links = [
        (l, '.' + l)
        for l in [
            'bash_profile',
            'bashrc',
            'clang-format',
            'flake8',
            'gitconfig',
            'tmux.conf',
            'vimrc'
        ]
    ]
    for srcname, destname in links:
        make_link(root.joinpath(srcname), args.directory.joinpath(destname),
                  dryrun=args.dryrun)

    dirs = [
        ('bash', '.bash'),
        ('bin', 'bin'),
        ('git', 'bin/git'),
        ('vim/ftplugin', '.vim/ftplugin')
    ]
    for srcname, destname in dirs:
        make_dir(root.joinpath(srcname), args.directory.joinpath(destname),
                 dryrun=args.dryrun)


def parse_args():
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


def make_dir(src, dest, dryrun=False):
    print(f'Installing {src} to {dest}')
    if (dest.is_symlink() or dest.exists()) and not dest.is_dir():
        backup(dest, dryrun=dryrun, indent=1)
    if not dryrun:
        dest.mkdir(parents=True, exist_ok=True)
    for f in src.glob('*'):
        make_link(f, dest.joinpath(f.name), dryrun=dryrun, indent=1)


def make_link(src, dest, dryrun=False, indent=0):
    tabs = '  ' * indent
    print(f'{tabs}Installing {src} to {dest}')
    directory = dest.parent
    if not dryrun:
        directory.mkdir(parents=True, exist_ok=True)
    if dest.is_symlink() or dest.exists():
        if dest.is_symlink() and os.readlink(dest) == str(src):
            print(f'{tabs}  {dest} already points to {src}')
            return
        else:
            backup(dest, dryrun=dryrun, indent=indent+1)
    if not dryrun:
        dest.symlink_to(src)


def backup(dest, dryrun=False, indent=0):
    tabs = '  ' * indent
    bak = dest.with_name(dest.name + '.bak')
    if bak.is_symlink() or bak.exists():
        backup(bak, dryrun=dryrun, indent=indent)
    print(f'{tabs}Backing up {dest} to {bak}')
    if not dryrun:
        dest.rename(bak)


if __name__ == '__main__':
    main()
