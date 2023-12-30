ARG BUILD_FROM
FROM $BUILD_FROM

ARG BUILD_VERSION
ARG BUILD_ARCH
ARG BASHIO_VERSION=0.14.3

LABEL \
  io.hass.version="$BUILD_VERSION" \
  io.hass.type="addon" \
  io.hass.arch="$BUILD_ARCH"

RUN \
  apk add --no-cache bash supervisor nginx yq jq; \
  rm -rf /var/cache/apk/*; \
  mkdir -p /usr/src/bashio \
  && curl -L -f -s "https://github.com/hassio-addons/bashio/archive/v${BASHIO_VERSION}.tar.gz" | tar -xzf - --strip 1 -C /usr/src/bashio \
  && mv /usr/src/bashio/lib /usr/lib/bashio \
  && ln -s /usr/lib/bashio/bashio /usr/bin/bashio

# Add some brief sanity checks
RUN \
  test -e /opt/reactor/dist-config/logging.yaml

SHELL ["/bin/bash", "-c"]

COPY run.sh /opt/reactor/run.sh
RUN chmod a+x run.sh

ADD nginx.conf /etc/nginx/http.d/default.conf
EXPOSE 8099

ADD supervisord.conf /etc/supervisord.conf
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

#CMD [ "/bin/bash", "-c", "/opt/reactor/run.sh" ]
