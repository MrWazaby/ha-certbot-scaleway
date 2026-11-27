# https://developers.home-assistant.io/docs/apps/guides/dockerfile/
ARG BUILD_FROM=ghcr.io/home-assistant/base:3.23
FROM ${BUILD_FROM}

ENV LANG=C.UTF-8 \
    PIP_BREAK_SYSTEM_PACKAGES=1

# certbot and the Scaleway DNS plugin are pure Python; their dependencies ship
# musllinux wheels for all supported architectures, so no compiler is needed.
RUN apk add --no-cache \
        bash \
        ca-certificates \
        curl \
        jq \
        python3 \
        py3-pip \
    && pip install --no-cache-dir \
        certbot \
        certbot-dns-scaleway

# Copy root filesystem
COPY rootfs /

LABEL \
    org.opencontainers.image.title="Home Assistant App: Certbot Scaleway" \
    org.opencontainers.image.description="Generate and auto-renew Let's Encrypt certificates using the Scaleway DNS API (certbot-dns-scaleway)." \
    org.opencontainers.image.source="https://github.com/MrWazaby/ha-certbot-scaleway" \
    org.opencontainers.image.licenses="MIT"
