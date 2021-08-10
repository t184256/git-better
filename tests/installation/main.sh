#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2021 git-better authors (see AUTHORS)
# SPDX-License-Identifier: License: GPL-3.0-or-later

set -ueo pipefail

echo 'output check: git-better'
[[ "$(git-better 2>&1)" == "$(git 2>&1)" ]]
echo 'output check: git-better clone'
[[ "$(git-better clone 2>&1)" == "$(git clone 2>&1)" ]]
echo 'output check: git-better vanilla-clone'
[[ "$(git-better vanilla-clone 2>&1)" == "$(git clone 2>&1)" ]]

echo 'remembering outputs...'
git_output=$(git 2>&1 || true)
git_clone_output=$(git clone 2>&1 || true)
echo 'setting up an alias...'
shopt -s expand_aliases
alias git="git-better"

echo 'aliased output check: git=git-better'
[[ "$(git 2>&1)" == "$git_output" ]]
echo 'aliased output check: git=git-better vanilla-clone'
[[ "$(git vanilla-clone 2>&1)" == "$git_clone_output" ]]
