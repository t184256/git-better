#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2021 git-better authors (see AUTHORS)
# SPDX-License-Identifier: License: GPL-3.0-or-later

set -uexo pipefail

echo 'Output check: git-better'
[[ "$(git-better 2>&1)" == "$(git 2>&1)" ]]
echo 'Output check: git-better clone'
[[ "$(git-better clone 2>&1)" == "$(git clone 2>&1)" ]]
