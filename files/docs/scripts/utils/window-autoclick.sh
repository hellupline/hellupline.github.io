#!/bin/bash

set -x

eval "$(xdotool search --shell --name 'Minecraft\* 1.18.2 - Multiplayer \(3rd-party Server\)')"
for WINDOW in ${WINDOWS[@]}; do
    eval "$(xdotool getwindowgeometry --shell "${WINDOW}")"
    NX="$((WIDTH * 50 / 100))"
    NY="$((HEIGHT * 75 / 100))"
    xdotool mousemove --window "${WINDOW}" "${NX}" "${NY}"; sleep 1
    # xdotool click --window "${WINDOW}" 1; sleep 1
    xdotool key --window "${WINDOW}" Escape; sleep 1
    xdotool mousedown --window "${WINDOW}" 1; sleep 1
done
