#!/bin/sh

# Usage:
# $ screenshot [selection|window|all] ["~/pictures/screenshots"]

# set -x # verbose
set -o pipefail # exit on pipeline error
set -e # exit on error
set -u # variable must exist

UTCNOW=$(date '+%Y-%m-%dT%T%z')
TYPE="${1:-selection}"
DIRECTORY="${2:-${HOME}/pictures/screenshots/}"
FILENAME="${DIRECTORY}/${UTCNOW}.png"

case "${TYPE}" in
  "selection")
    maim --highlight --color=1.0,1.0,1.0,0.5 --hidecursor \
      --select "${FILENAME}"
    ;;

  "window")
    maim --highlight --color='1.0,1.0,1.0,0.5' --hidecursor \
      --window "$(xdotool getactivewindow)" "${FILENAME}"
    ;;

  "all")
    maim --highlight --color=1.0,1.0,1.0,0.5 --hidecursor \
      "${FILENAME}"
    ;;
esac

notify-send -u normal -- "${FILENAME} saved"
echo "${FILENAME}"

xclip -selection clipboard -t image/png -i "${FILENAME}"
