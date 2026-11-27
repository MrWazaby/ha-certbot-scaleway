#!/usr/bin/with-contenv bashio
# ==============================================================================
# Certbot deploy hook: copy the issued/renewed certificate into the ssl share
# so Home Assistant and other apps can use it.
# ==============================================================================

if bashio::var.is_empty "${RENEWED_LINEAGE:-}"; then
    bashio::log.error "RENEWED_LINEAGE is not set, nothing to deploy."
    exit 1
fi

mkdir -p /ssl
install -m 0644 "${RENEWED_LINEAGE}/fullchain.pem" /ssl/fullchain.pem
install -m 0600 "${RENEWED_LINEAGE}/privkey.pem" /ssl/privkey.pem
bashio::log.info "Certificate deployed to /ssl/fullchain.pem and /ssl/privkey.pem"
