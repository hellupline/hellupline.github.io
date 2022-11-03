#!/bin/sh

# Usage:
# $ utcnow

# set -x # verbose
set -o pipefail # exit on pipeline error
set -e # exit on error
set -u # variable must exist

date --iso-8601=seconds --utc
