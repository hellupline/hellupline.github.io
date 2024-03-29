#!/bin/sh

# Usage:
# $ lets-encrypt-cloudflare "CLOUDFLARE_API_KEY" "hellupline.dev" "root@hellupline.dev"

# set -x # verbose
set -o pipefail # exit on pipeline error
set -e # exit on error
set -u # variable must exist

die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 3 ] || die "3 argument required, $# provided"

CLOUDFLARE_API_KEY="${1}"
DOMAIN="${2}"
EMAIL="${3}"
echo "dns_cloudflare_api_key=${CLOUDFLARE_API_KEY}\ndns_cloudflare_email=${EMAIL}" > dns-cloudflare.ini
chmod 400 dns-cloudflare.ini

docker run --rm -it --name certbot \
    --volume "${PWD}/var-lib-letsencrypt:/var/lib/letsencrypt" \
    --volume "${PWD}/etc-letsencrypt:/etc/letsencrypt" \
    --volume "${PWD}/dns-cloudflare.ini:/dns-cloudflare.ini" \
    certbot/dns-cloudflare \
    certonly --dry-run \
        --manual-public-ip-logging-ok --agree-tos --email="${EMAIL}" \
        --dns-cloudflare \
        --dns-cloudflare-credentials /dns-cloudflare.ini \
        --domains="${DOMAIN}"
