#!/bin/sh

# Usage:
# $ show-certs "hellupline.dev"

# set -x # verbose
set -o pipefail # exit on pipeline error
set -e # exit on error
set -u # variable must exist

LAST=""
while :; do
    CURRENT=$(xclip -selection primary -out)
    if [ "${CURRENT}" != "${LAST}" ]; then
        notify-send -- "Added ${CURRENT}"
        LAST="${CURRENT}"
        echo "${CURRENT}"
    fi
    sleep .1
done
