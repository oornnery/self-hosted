FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends unbound dnsutils ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY unbound.conf /etc/unbound/unbound.conf.d/pi-hole.conf

RUN mkdir -p /var/lib/unbound /var/run/unbound \
    && chown -R unbound:unbound /var/lib/unbound /var/run/unbound

CMD ["unbound", "-d", "-c", "/etc/unbound/unbound.conf.d/pi-hole.conf"]
