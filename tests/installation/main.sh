#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2021 git-better authors (see AUTHORS)
# SPDX-License-Identifier: License: GPL-3.0-or-later

set -ueo pipefail

[[ "${FROZEN:-0}" != 1 ]] && \
	FROZEN=1 exec faketime -f '2000-01-01 00:00:00' bash "$0"

ORIGINAL_GIT=$(command -v git)
deterministic_reclone() {
	# assumes time's already frozen, otherwise there's more nondeterminism
	from=$1; to=$2
	ln -s "$1" neutral_location
	$ORIGINAL_GIT clone neutral_location "$2"
	rm neutral_location
	pushd "$2"
		rm .git/index
		$ORIGINAL_GIT repack -Ad --threads=1
	popd
}


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
	alias git-original=$ORIGINAL_GIT
	alias git=git-better

echo 'aliased output check: git=git-better'
	[[ "$(git 2>&1)" == "$(git-original 2>&1)" ]]
echo 'aliased output check: git=git-better vanilla-clone'
	[[ "$(git vanilla-clone 2>&1)" == "$(git-original clone 2>&1)" ]]

echo 'smoke test: loosely compare two clones'
	git-original clone repo clone-original
	sleep 2
	git vanilla-clone repo clone-better
	diff --exclude index -ur clone-original clone-better

echo 'smoke test: strictly compare their re-clones'
	deterministic_reclone clone-original reclone-original
	deterministic_reclone clone-better reclone-better
	diff -ur reclone-original reclone-better
