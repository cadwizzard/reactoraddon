ARG BUILD_FROM
FROM ${BUILD_FROM}

ARG BUILD_VERSION
ARG BUILD_ARCH
ARG BASHIO_VERSION=0.14.3

LABEL \
  io.hass.version="${BUILD_VERSION}" \
  io.hass.type="addon" \
  io.hass.arch="${BUILD_ARCH}"

RUN set -eux; \
    if command -v apk >/dev/null 2>&1; then \
        apk add --no-cache bash supervisor nginx yq jq curl ca-certificates; \
    elif command -v apt-get >/dev/null 2>&1; then \
        apt-get update; \
        DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
            bash supervisor nginx yq jq curl ca-certificates; \
        rm -rf /var/lib/apt/lists/*; \
    else \
        echo "Unsupported base image: neither apk nor apt-get is available" >&2; \
        exit 1; \
    fi; \
    mkdir -p /usr/src/bashio; \
    curl -LfsS "https://github.com/hassio-addons/bashio/archive/v${BASHIO_VERSION}.tar.gz" \
      | tar -xzf - --strip-components=1 -C /usr/src/bashio; \
    mv /usr/src/bashio/lib /usr/lib/bashio; \
    ln -sf /usr/lib/bashio/bashio /usr/bin/bashio

RUN test -e /opt/reactor/dist-config/logging.yaml

SHELL ["/bin/bash", "-c"]

COPY run.sh /opt/reactor/run.sh
RUN chmod a+x /opt/reactor/run.sh

COPY nginx.conf /tmp/reactor-nginx.conf
RUN set -eux; \
    if command -v apk >/dev/null 2>&1; then \
        mkdir -p /etc/nginx/http.d; \
        mv /tmp/reactor-nginx.conf /etc/nginx/http.d/default.conf; \
    else \
        rm -f /etc/nginx/sites-enabled/default /etc/nginx/conf.d/default.conf; \
        mkdir -p /etc/nginx/conf.d; \
        mv /tmp/reactor-nginx.conf /etc/nginx/conf.d/default.conf; \
    fi

COPY supervisord.conf /etc/supervisord.conf

EXPOSE 8111

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
