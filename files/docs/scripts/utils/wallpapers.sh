#!/bin/sh

# Usage:
# $ SLEEP=60 wallpapers ~/wallpapers

# set -x # verbose
set -o pipefail # exit on pipeline error
set -e # exit on error
set -u # variable must exist

die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -gt 0 ] || die "1 argument required, $# provided"

SOURCES=${@}

while true; do
    feh --recursive --randomize --bg-max --no-fehbg ${SOURCES[@]}
    sleep "${SLEEP:-60}"
done
