# SPDX-FileCopyrightText: 2021 git-better authors (see AUTHORS)
# SPDX-License-Identifier: License: GPL-3.0-or-later

import git_better.main


def call_main(mocker, argv, expected_cmd):
    import sys
    mocker.patch('git_better.main._exec')
    mocker.patch.object(sys, 'argv', argv)
    git_better.main.main()
    git_better.main._exec.assert_called_once_with(*expected_cmd)


def test_vanilla_clone_interception(mocker):
    call_main(mocker,
              ['git', 'vanilla-clone', '<url>'],
              ['git', 'clone', '<url>'])


def test_passthrough_aliased_with_args(mocker):
    call_main(mocker, ['git', 'clone', '<url>'], ['git', 'clone', '<url>'])


def test_passthrough_empty(mocker):
    call_main(mocker, ['git-better'], ['git'])


def test_exec(mocker):
    import subprocess
    import sys
    mock_process = mocker.MagicMock()
    mock_process.returncode = 7
    mocker.patch('subprocess.run', return_value=mock_process)
    mocker.patch('sys.exit')
    git_better.main._exec('abc', 'def', 'xyz')
    subprocess.run.assert_called_once_with(('abc', 'def', 'xyz'))
    sys.exit.assert_called_once_with(7)
