#!/bin/sh

# Usage:
# $ spotifyctl

# set -x # verbose
set -o pipefail # exit on pipeline error
set -e # exit on error
set -u # variable must exist

die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 1 ] || die "1 argument required, $# provided"

COMMAND="${1}"

[ "$(pidof spotify)"  != "" ] || die "Spotify not running!"

case "${COMMAND}" in
    "play"|"pause"|"playpause")
        dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause
        ;;
    "next")
        dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next
        ;;
    "prev")
        dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous
        ;;
    *)
        echo "Unknown command: " $1
esac
