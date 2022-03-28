#!/bin/bash

set -Eeuxo pipefail

cd "$GIT_ROOT"
now=$(cat "$NOW")
message="$now"$'\n\n'"Snapshot of e-Gov法令検索 as of $now"$'\n\n'"$(grep -vi cookie "$HEADERS")"
git init
git config --local user.name elaws-history
git config --local user.email elaws-history@eki.do
git remote add origin git@github.com:kissge/elaws-history.git
git fetch --depth 1
git reset origin/master --soft
GLOBIGNORE=".git:$ALL_XML_DIRECTORY_NAME"
git restore --staged *
git restore *
git add .
git commit -m "Archive: $message"
git tag -am "$message" "$now"
git push --follow-tags
