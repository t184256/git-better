#!/usr/bin/env python
# SPDX-FileCopyrightText: 2021 git-better authors (see AUTHORS)
# SPDX-License-Identifier: GPL-3.0-or-later

import subprocess
import sys


def vanilla_clone(*args):
    """Fall back to `git clone` with no modifications.
    """
    _exec('git', 'clone', *args)


def main():
    """Execute a subcommand, falling back to git if unrecognized.
    """
    if len(sys.argv) > 1 and sys.argv[1] == 'vanilla-clone':
        vanilla_clone(*sys.argv[2:])
    else:
        _exec('git', *sys.argv[1:])


def _exec(*cmd):
    """Execute a command and exit the whole process, using child's return code.
    """
    sys.exit(subprocess.run(cmd).returncode)


if __name__ == '__main__':
    main()
