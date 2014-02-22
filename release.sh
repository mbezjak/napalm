#!/bin/bash
#
# Note: this uses commands from https://github.com/mbezjak/poly-devel

set -o errexit

declare -r version="$1"

function validate-changelog {
    grep -q "^# $version" Changelog.md ||
        fail "Missing changelog entry for version: $version"
}

validate-version-set "$version"
validate-uncommited
validate-not-tagged "$version"
validate-new-version "$version"
validate-changelog

update-version "$version"
validate-version-match "$version"

repo-commit-all "RELEASE $version"
git tag --annotate "$version" --message="Tag for release $version"
git push
git push --tags

exit 0
