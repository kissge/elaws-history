#!/bin/bash

set -Eeuxo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

export WORKDIR="$PWD"/workdir
export GIT_ROOT="$WORKDIR"/git_root
export ALL_XML_DIRECTORY_NAME=all_xml
export NOW="$WORKDIR"/now
export HEADERS="$WORKDIR"/headers
export EH_VERSION=$(git describe)
export USER_AGENT="Mozilla/5.0 (compatible; elaws-history/$EH_VERSION; +https://github.com/kissge/elaws-history)"
export GIT_REMOTE_URL=${GIT_REMOTE_URL:-git@github.com:kissge/elaws-history.git}

function _bash() {
  echo "::group::bash $1" &&
    bash "$1" &&
    echo "::endgroup::"
}

_bash src/cleanup.sh
_bash src/get-files.sh
_bash src/push.sh
