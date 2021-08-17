#!/usr/bin/env python
# SPDX-FileCopyrightText: 2021 git-better authors (see AUTHORS)
# SPDX-License-Identifier: GPL-3.0-or-later

import os
import select
import subprocess
import sys
import time


def _proceed_in_backgrounded_child(child_func):
    pipe_read, pipe_write = os.pipe()
    pipe_read = os.fdopen(pipe_read)
    pipe_write = os.fdopen(pipe_write, 'w', buffering=1)

    def log(*args, **kwargs):
        try:
            print(*args, **kwargs, file=pipe_write)
        except BrokenPipeError:
            pass

    p = os.fork()
    if p == 0:  # child
        pipe_read.close()
        child_func(log=log)
        try:
            pipe_write.close()
        except BrokenPipeError:
            pass
        sys.exit(0)
    else:  # parent
        pipe_write.close()
        while True:
            fds = [sys.stdin, pipe_read]
            readables, _, exceptables = select.select(fds, [], fds)
            if pipe_read in readables or pipe_read in exceptables:
                l = pipe_read.readline()
                if not l:
                    pipe_read.close()
                    return True  # child has finished doing what it's doing
                print(l[:-1])  # sans the newline
            if sys.stdin in readables or sys.stdin in exceptables:
                return False  # interrupted manually before child has exited


def unshallow(repo_path=os.curdir,
              log=lambda *a, **kwa: print(*a, **kwa, file=sys.stderr)):
    """Gradually fetch more and more of repo's history.
    """
    fetch = ['git', 'fetch', '-q']
    def fetch(*args, **kwargs):
        subprocess.run(['git', 'fetch', '-q', *args], cwd=repo_path, **kwargs)
    log('deepening to 1 week ago...')
    fetch('--shallow-since=1 week', check=False)
    log('deepening to 1 year ago...')
    fetch('--shallow-since=1 year', check=False)
    log('deepening to full depth...')
    fetch('--unshallow', check=True)
    log('fetching tags...')
    fetch('-t', check=True)


def impatient_clone(what, where):
    """Clone with `--depth=1`, backgrounds itself, unshallows in background.
    """
    print('cloning at depth=1...', file=sys.stderr)
    subprocess.run(['git', 'clone', '--depth=1', what, where])
    print('unshallowing. press return to background...',
          file=sys.stderr)
    def child_func(log):
        return unshallow(where, log)
    completed = _proceed_in_backgrounded_child(child_func)
    if completed:
        print('unshallowing has completed', file=sys.stderr)
    else:
        print('unshallowing will continue in the background', file=sys.stderr)


def vanilla_clone(*args):
    """Fall back to `git clone` with no modifications.
    """
    _exec('git', 'clone', *args)


def main():
    """Execute a subcommand, falling back to git if unrecognized.
    """
    if len(sys.argv) > 1 and sys.argv[1] == 'vanilla-clone':
        vanilla_clone(*sys.argv[2:])
    elif len(sys.argv) > 1 and sys.argv[1] == 'impatient-clone':
        impatient_clone(*sys.argv[2:])
    elif len(sys.argv) > 1 and sys.argv[1] == 'unshallow':
        unshallow()
    else:
        _exec('git', *sys.argv[1:])


def _exec(*cmd, **kwargs):
    """Execute a command and exit the whole process, using child's return code.
    """
    sys.exit(subprocess.run(cmd, **kwargs).returncode)


if __name__ == '__main__':
    main()
