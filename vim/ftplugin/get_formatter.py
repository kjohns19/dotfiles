#!/usr/bin/env python3.12

''' This script is intended to be run by the vim C/C++ format commands (see c.vim)

It will return the path to the latest installed clang-format.py script that can
be used in vim to format C and C++ code
'''

import pathlib
import re
import sys


def main() -> None:
    formatter = find_formatter()
    if formatter is None:
        print('No formatter found. Is clang-format installed?', end='')
        sys.exit(1)
    print(formatter, end='')


def find_formatter() -> pathlib.Path | None:
    pattern = re.compile('clang-format-([0-9]+)')
    matching_paths = (
        (path, pattern.match(path.name))
        for path in pathlib.Path('/usr/share/clang').glob('clang-format-*')
    )
    versioned_paths = (
        (path / 'clang-format.py', int(match.group(1)))
        for path, match in matching_paths
        if match is not None
    )
    return max(versioned_paths, default=(None, 0), key=lambda x: x[1])[0]


if __name__ == '__main__':
    main()
