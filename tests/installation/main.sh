#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2021 git-better authors (see AUTHORS)
# SPDX-License-Identifier: License: GPL-3.0-or-later

set -ueo pipefail


echo 'setup: temporary directory'
	tmpdir=$(realpath $(mktemp -d))
	trap '[[ "$tmpdir" =~ /tmp. ]]; cd -; rm -rf "$tmpdir" ' EXIT
	cd $tmpdir

echo 'setup: git repo'
	export GIT_AUTHOR_NAME=test
	export GIT_AUTHOR_EMAIL=test@example.org
	export GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME
	export GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL
	mkdir repo
	pushd repo
		git init
		echo 1 > a
		git add a
		git commit -m 'initial commit'
		echo 2 > a
		git add a
		git commit -m 'second commit'
	popd
	unset GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL
	unset GIT_COMMITTER_NAME GIT_COMMITTER_EMAIL

echo 'output check: git-better'
	[[ "$(git-better 2>&1)" == "$(git 2>&1)" ]]
echo 'output check: git-better clone'
	[[ "$(git-better clone 2>&1)" == "$(git clone 2>&1)" ]]
echo 'output check: git-better vanilla-clone'
	[[ "$(git-better vanilla-clone 2>&1)" == "$(git clone 2>&1)" ]]

echo 'setup: alias'
	shopt -s expand_aliases
	alias git-original="$(command -v git)"
	alias git=git-better

echo 'aliased output check: git=git-better'
	[[ "$(git 2>&1)" == "$(git-original 2>&1)" ]]
echo 'aliased output check: git=git-better vanilla-clone'
	[[ "$(git vanilla-clone 2>&1)" == "$(git-original clone 2>&1)" ]]

echo 'smoke test: compare two clones'
	git-original clone repo clone-original
	git vanilla-clone repo clone-better
	diff --exclude logs --exclude index -r clone-original clone-better
