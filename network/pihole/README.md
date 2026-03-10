# Pi-hole + Unbound

DNS filtering plus local recursive resolution.

## What This Stack Assumes

- You have a real host interface IP available for DNS binding.
- Port `53` on that IP is free.
- You only need DNS and the web UI. DHCP is intentionally disabled.

## Quick Start

```bash
cp .env.example .env
docker compose config
docker compose up -d
docker compose ps
```

## Host Access

- DNS: `${PIHOLE_BIND_IP}:53`
- Web UI: `http://localhost:8090/admin`
- Optional Traefik route: `https://pihole.localhost:8443/admin/`

## Useful Adjustments

- Set `PIHOLE_BIND_IP` to a real address on the host, not `127.0.0.1`.
- Set `FTLCONF_webserver_api_password` before exposing the web UI.
- Keep `FTLCONF_dns_upstreams=unbound#5335` unless you intentionally want external upstream DNS.

## Quick Checks

```bash
docker compose ps
docker compose logs -f unbound
docker compose logs -f pihole
curl -I http://127.0.0.1:8090/admin/
```

## Quick Debug Notes

- If the stack fails early, `unbound` is the first thing to check.
- If DNS cannot bind, another resolver is already using port `53` on the chosen IP.
- If you ever enable DHCP later, you will also need to expose `67/udp` and revisit capabilities.
