#!/bin/sh

# Usage:
# $ make-cacert "hellupline.dev"

# set -x # verbose
set -o pipefail # exit on pipeline error
set -e # exit on error
set -u # variable must exist

DOMAIN=${1:-localhost}

mkdir -p tls-certs

# create rootca certs
openssl genrsa -out tls-certs/rootca.key 4096
openssl req -x509 \
    -new -nodes -sha256 -days 3650 \
    -key tls-certs/rootca.key \
    -out tls-certs/rootca.cert \
    -subj "/CN=${DOMAIN}/O=${DOMAIN}/OU=${DOMAIN}"

# certutil -d sql:$HOME/.pki/nssdb -A -n 'personal cert authority' -i ./tls-certs/rootca.cert -t TCP,TCP,TCP
