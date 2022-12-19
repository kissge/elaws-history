#!/bin/bash

set -Eeuo pipefail

git log --oneline --decorate=no --grep='Archive: ' | while read -r sha _ tag; do
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
    GIT_COMMITTER_DATE="$orig_date" git -c user.name="$orig_name" -c user.email="$orig_email" \
        tag --force --annotate --message "$orig_msg" "$tag" "$sha"
done

echo 'Done'
