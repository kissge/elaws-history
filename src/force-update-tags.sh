#!/bin/bash

set -Eeuo pipefail

echo "Backup git local config"
cp .git/config{,.bak}
before=$(md5sum .git/config)

function finally() {
    if ! diff -qs .git/config{,.bak}; then
        echo "Restore git local config"
        cp .git/config{.bak,}
        after=$(md5sum .git/config)

        if [ "$before" != "$after" ]; then
            echo "Something went wrong ($before != $after)"
            exit 1
        fi
    fi

    echo OK
}

trap finally EXIT

git log --oneline --decorate=no | grep -F 'Archive: ' | while read -r sha _ tag; do
    if [ -z "$(git tag --list "$tag")" ]; then
        echo "Tag $tag doesn't exist. I don't know what to do. Skipping."
        continue
    fi

    orig_sha=$(git tag --list --format='%(object)' "$tag")
    orig_date=$(git tag --list --format='%(taggerdate)' "$tag")
    orig_msg=$(git tag --list --format='%(contents)' "$tag")
    orig_name=$(git tag --list --format='%(taggername)' "$tag")
    orig_email=$(git tag --list --format='%(taggeremail:trim)' "$tag")

    echo Rewriting tag "$tag" from "$orig_sha" to "$sha"
    git config --local user.name "$orig_name"
    git config --local user.email "$orig_email"
    GIT_COMMITTER_DATE="$orig_date" git tag --force --annotate --message "$orig_msg" "$tag" "$sha"
done

echo 'Done'
