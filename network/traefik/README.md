# Traefik + CrowdSec

Local edge stack with TLS, host-based routing, and lightweight request filtering.

## What This Stack Assumes

- The backend stacks are already running and publishing host ports.
- This stack is the last layer, not the first one.
- You want low-cost local TLS and simple hostname routing.

## Quick Start

```bash
cp .env.example .env
docker compose config
docker compose up -d
docker compose ps
```

## Host Access

- `http://localhost:8088`
- `https://localhost:8443`
- `http://127.0.0.1:8089` for the local Traefik dashboard

## Ready Hostnames

- `https://traefik.localhost:8443`
- `https://site.localhost:8443`
- `https://homarr.localhost:8443`
- `https://openwebui.localhost:8443`
- `https://librechat.localhost:8443`
- `https://signoz.localhost:8443`
- `https://pihole.localhost:8443`
- `https://headscale.localhost:8443`

## Useful Adjustments

- Change edge ports in `.env` if `8088`, `8443`, or `8089` conflict with the host.
- Update `dynamic/routes.yml` when a backend host port changes.
- If you rotate `CROWDSEC_TRAEFIK_BOUNCER_KEY`, update `dynamic/middlewares.yml` too.

## Quick Checks

```bash
curl http://127.0.0.1:8089/ping
curl -k -I -H 'Host: site.localhost' https://127.0.0.1:8443/
docker compose logs -f traefik
docker compose logs -f crowdsec
```

## Quick Debug Notes

- Routes fail most often because the backend host port changed and `dynamic/routes.yml` was not updated.
- The stack uses `host.docker.internal` to reach already-published services, so the backend must be reachable from the host first.
- If only protected routes fail, check the CrowdSec bouncer settings before changing Traefik itself.
