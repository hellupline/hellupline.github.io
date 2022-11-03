#!/bin/sh

# Usage:
# $ git-cleanup

# set -x # verbose
set -o pipefail # exit on pipeline error
set -e # exit on error
set -u # variable must exist

git checkout master
git pull
git remote prune origin
git branch --merged | grep --extended-regexp --invert-match "(^\*|master|dev)" | xargs git branch --delete
