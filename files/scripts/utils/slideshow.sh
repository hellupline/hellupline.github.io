#!/bin/sh

# Usage:
# $ slideshow ~/wallpapers

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

feh --scale-down --fullscreen --sort filename --reverse ${SOURCES[@]}
