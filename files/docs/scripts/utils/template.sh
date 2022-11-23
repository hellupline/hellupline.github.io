#!/bin/bash

# set -o verbose # verbose
# set -o xtrace # debug
set -o pipefail # exit on pipeline error
set -o nounset # variable must exist
# set -o errexit # exit on error
set -o errtrace # trace on error

trap 'echo "ERR trap called in ${FUNCNAME-main context} on line ${LINENO}"; exit 1' ERR

# exec 4>&1 5>&2 \
#     3> >(logger --skip-empty --tag WARNING --stderr 2>&4) \
#     1> >(logger --skip-empty --tag INFO --stderr 2>&4) \
#     2> >(logger --skip-empty --tag ERROR --stderr 2>&5)

# die () {
#     echo -e "$@" >&2
#     exit 1
# }

# WARNING () {
#     echo -e "$@" >&3
# }

# ERROR () {
#     echo -e "$@" >&2
# }

# INFO () {
#     echo -e "$@"
# }


# for I in $(seq 9); do WARNING "3: ${I}"; done
# for I in $(seq 9); do INFO "1: ${I}"; done
# for I in $(seq 9); do ERROR "2: ${I}"; done
