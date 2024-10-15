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

if [[ "$METHOD" == "GET" && "$P" == ${ROUTE_PATH}/plantings/* ]]; then
    NAME="${P#${ROUTE_PATH}/plantings/}"
    if [[ -f "plantings/$NAME.md" ]]; then
        meta_out headers="$(jo "content-type"="text/html")"
        exec ./render-apage.nu "plantings/$NAME.md"
    fi
fi

if [[ "$METHOD" == "GET" && "$P" == ${ROUTE_PATH}/quick/* ]]; then
    NAME="${P#${ROUTE_PATH}/quick/}"
    if [[ -f "quick/$NAME" ]]; then
        meta_out headers="$(jo "content-type"="text/html")"
        exec jo stack_id="$NAME" | minijinja-cli --safe-path ./quick --safe-path . --safe-path ./quick -f json quick.html -
    fi
fi

if [[ "$METHOD" == "GET" && "$P" == "${ROUTE_PATH}/styles.css" ]]; then
    meta_out headers="$(jo "content-type"="text/css")"
    exec cat styles.css
fi

meta_out status=404 headers="$(jo "content-type"="text/html")"
echo "Not Found:" $METHOD $P
