#!/usr/bin/env bash
# ==============================================================================
# Certbot deploy hook: copy the issued/renewed certificate into the ssl share
# so Home Assistant and other apps can use it.
# Plain bash shebang on purpose: `with-contenv` clears the caller environment
# unless S6_KEEP_ENV=1, which would drop certbot's RENEWED_LINEAGE.
# ==============================================================================

# shellcheck source=/usr/lib/bashio/bashio.sh
source /usr/lib/bashio/bashio.sh

lineage="${1:-${RENEWED_LINEAGE:-}}"

if bashio::var.is_empty "${lineage}"; then
    bashio::log.error "RENEWED_LINEAGE is not set, nothing to deploy."
    exit 1
fi

mkdir -p /ssl
install -m 0644 "${lineage}/fullchain.pem" /ssl/fullchain.pem
install -m 0600 "${lineage}/privkey.pem" /ssl/privkey.pem
bashio::log.info "Certificate deployed to /ssl/fullchain.pem and /ssl/privkey.pem"
