#!/bin/sh

# Usage:
# $ ssl-cipher-tester"hellupline.dev:443"

# set -x # verbose
set -o pipefail # exit on pipeline error
set -e # exit on error
set -u # variable must exist

# OpenSSL requires the port number.
SERVER=${1:-localhost}
DELAY=1
CIPHERS=$(openssl ciphers 'ALL:eNULL' | sed -e 's/:/ /g')

echo "Obtaining cipher list from $(openssl version)."

for CIPHER in ${CIPHERS[@]}; do
    echo -n "Testing ${CIPHER}..."
    RESULT=$(openssl s_client -cipher "$CIPHER" -connect $SERVER < /dev/null 2>&1)
    if [[ "${RESULT}" =~ ":error:" ]]; then
        ERROR=$(echo -n "${RESULT}" | cut -d':' -f6)
        echo "NO (${ERROR})"
    else
        if [[ "${RESULT}" =~ "Cipher is ${CIPHER}" || "${RESULT}" =~ "Cipher    :" ]]; then
            echo YES
        else
            echo 'UNKNOWN RESPONSE'
            echo "${RESULT}"
        fi
    fi
    sleep "${DELAY}"
done
