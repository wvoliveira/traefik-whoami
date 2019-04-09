FROM traefik:1.7.9-alpine

RUN apk add --update \
  curl \
  && rm -rf /var/cache/apk/*

COPY conf/traefik.toml /etc/traefik/traefik.toml
COPY conf/rules /etc/traefik/rules
COPY conf/certs /etc/traefik/certs

EXPOSE 80 443 8080

HEALTHCHECK --interval=10s --timeout=5s --start-period=10s --retries=5 \
  CMD curl -f http://localhost:8080/ping || exit 1
