#!/bin/bash

set -Eeuxo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

export WORKDIR="$PWD"/workdir
export GIT_ROOT="$WORKDIR"/git_root
export ALL_XML_DIRECTORY_NAME=all_xml
export NOW="$WORKDIR"/now
export HEADERS="$WORKDIR"/headers

bash src/cleanup.sh
bash src/get-files.sh
bash src/push.sh
