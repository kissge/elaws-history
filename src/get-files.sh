#!/bin/bash

set -Eeuxo pipefail

mkdir -p "$WORKDIR"
TZ=Asia/Tokyo date +%Y/%m/%dT%H%M%S.%N%z >"$NOW"
zip="$WORKDIR"/all_xml.zip
curl -D "$HEADERS" -A "$USER_AGENT" -o "$zip" 'https://laws.e-gov.go.jp/bulkdownload?file_section=1&only_xml_flag=true'

mkdir -p "$GIT_ROOT" && cd $_
mkdir -p "$ALL_XML_DIRECTORY_NAME" && cd $_
unzip "$zip"

# 加工 (1) サブディレクトリ化

echo */ | tr ' ' '\n' | cut -c -3 | uniq | while read -r prefix; do
    mkdir -p "$prefix"
    mv "$prefix"*_*/ "$prefix"/
done

# 加工 (2) 文字コード変換

# 削除
