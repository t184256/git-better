#!/usr/bin/env bash
set -uexo pipefail

echo 'Output check'
[[ "$(project-name)" == "Hello world!" ]]  # TODO: replace
