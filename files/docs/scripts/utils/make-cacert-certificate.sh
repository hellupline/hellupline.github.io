#!/bin/sh

# Usage:
# $ make-cacert-certificate "hellupline.dev"

# set -x # verbose
set -o pipefail # exit on pipeline error
set -e # exit on error
set -u # variable must exist

DOMAIN=${1:-localhost}

# create application certs
openssl genrsa -out tls-certs/service.key 4096
openssl req \
    -new -nodes -sha256 -days 3650 \
    -key tls-certs/service.key \
    -out tls-certs/service.csr \
    -subj "/CN=${DOMAIN}/O=${DOMAIN}/OU=${DOMAIN}" \
    -addext "subjectAltName = DNS:${DOMAIN},IP:::1,IP:127.0.0.1"

openssl x509 -req -sha256 \
    -CA tls-certs/rootca.cert \
    -CAkey tls-certs/rootca.key \
    -CAcreateserial \
    -in tls-certs/service.csr \
    -out tls-certs/service.pem \
    -extfile <( \
        echo 'authorityKeyIdentifier=keyid,issuer'; \
        echo 'basicConstraints=CA:FALSE'; \
        echo 'keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment'; \
        echo "subjectAltName = DNS:${DOMAIN},IP:::1,IP:127.0.0.1"; \
    )
