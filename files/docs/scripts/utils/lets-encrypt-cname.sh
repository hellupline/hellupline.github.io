#!/bin/sh

# Usage:
# $ lets-encrypt-cname "hellupline.dev" "root@hellupline.dev"

# set -x # verbose
set -o pipefail # exit on pipeline error
set -e # exit on error
set -u # variable must exist

die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 2 ] || die "2 argument required, $# provided"

DOMAIN="${1}"
EMAIL="${2}"

docker run --rm -it --name certbot \
    --volume "${PWD}/var-lib-letsencrypt:/var/lib/letsencrypt" \
    --volume "${PWD}/etc-letsencrypt:/etc/letsencrypt" \
    certbot/certbot \
    certonly --dry-run \
        --manual-public-ip-logging-ok --agree-tos --email="${EMAIL}" \
        --manual \
        --preferred-challenges=dns \
        --domains="${DOMAIN}"
