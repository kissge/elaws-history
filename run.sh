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

bash src/cleanup.sh
bash src/get-files.sh
bash src/push.sh
