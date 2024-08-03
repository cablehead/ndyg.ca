#!/usr/bin/env bash

set -eu

# you can export a ROUTE_PATH to place this service under a url prefix
ROUTE_PATH=${1:-"/"}
export ROUTE_PATH=${ROUTE_PATH%/}

BASE="$(dirname "$0")"
cd "$BASE"

meta_out() {
    jo "$@" >&4
    exec 4>&-
}

META="$(cat <&3)"

METHOD="$(jq -r .method <<<"$META")"

P="$(jq -r .path <<<"$META")"
P=${P%/}

if [[ "$METHOD" == "GET" && "$P" == "${ROUTE_PATH}" ]]; then
    meta_out headers="$(jo "content-type"="text/html")"
    exec ./render.nu
fi

if [[ "$METHOD" == "GET" && "$P" == "${ROUTE_PATH}/plantings/how-do-you-make-a-living" ]]; then
    meta_out headers="$(jo "content-type"="text/html")"
    cat ./how-do-you-make-a-living.md | md2html > content.html 
    minijinja-cli ./how-do-you-make-a-living.html
    exit
fi

if [[ "$METHOD" == "GET" && "$P" == "${ROUTE_PATH}/styles.css" ]]; then
    meta_out headers="$(jo "content-type"="text/css")"
    exec cat styles.css
fi

meta_out status=404 headers="$(jo "content-type"="text/html")"
echo "Not Found:" $METHOD $P
