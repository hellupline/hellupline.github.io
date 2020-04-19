#!/bin/sh

# Usage:
# $ cached "cache-file" "command"

# set -x # verbose
set -o pipefail # exit on pipeline error
set -e # exit on error
set -u # variable must exist

die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 2 ] || die "2 argument required, $# provided"

FILENAME="${1}"
COMMAND="${2}"

if [ -f "${FILENAME}" ]; then
    cat "${FILENAME}"
else
    sh -c "${COMMAND}" | tee "${FILENAME}"
fi
