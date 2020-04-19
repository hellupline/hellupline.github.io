#!/bin/sh

# Usage:
# $ play-random ./

# set -x # verbose
set -o pipefail # exit on pipeline error
set -e # exit on error
set -u # variable must exist

find "${@}" -type f \
            -regextype posix-egrep \
            -regex '.*\.(avi|mkv|mp4|wmv|flv|webm)$' \
            -printf '%T@ %p\n' \
    | sort -k1nr \
    | cut -d' ' -f2- \
    | xargs -d'\n' mpv -quiet
