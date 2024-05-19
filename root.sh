#!/usr/bin/env bash

set -eu

ROUTE_PATH=${1:-"/"}
# we export to make it available in the tera template
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
    cat index.html
    # jo request="$META" | tera --env --env-key ENV -i --template html/index.html --stdin
    exit
fi

meta_out status=404 headers="$(jo "content-type"="text/html")"
echo "Not Found:" $METHOD $P
