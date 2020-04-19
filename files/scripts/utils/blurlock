#!/bin/sh

# Usage:
# $ blurlock

# set -x # verbose
set -o pipefail # exit on pipeline error
set -e # exit on error
set -u # variable must exist

SCREENSHOT=$(mktemp --suffix=.png)
BLUR=$(mktemp --suffix=.png)

# take screenshot
gm import -window root ${SCREENSHOT}

# blur it
gm convert ${SCREENSHOT} -blur 0x5 ${BLUR}
rm ${SCREENSHOT}

# lock the screen
i3lock -i ${BLUR}

# sleep 1 adds a small delay to prevent possible race conditions with suspend
sleep 1
