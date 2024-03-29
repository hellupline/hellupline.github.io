#!/bin/sh

# Usage:
# $ cat data.tsv | tabular "|"

# set -x # verbose
set -o pipefail # exit on pipeline error
set -e # exit on error
set -u # variable must exist

SEPARATOR="${1:-|}"

column -t -s "${SEPARATOR}" | less -RS
