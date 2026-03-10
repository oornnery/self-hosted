# Homarr

Lightweight dashboard for links, shortcuts, and a quick view of the host.

## What This Stack Assumes

- Port `80` is free on the host, or you changed `HOMARR_PORT`.
- You are okay with mounting the Docker socket read-only for service discovery and widgets.

## Quick Start

```bash
cp .env.example .env
docker compose config
docker compose up -d
docker compose ps
```

## Host Access

- `http://localhost`
- `https://homarr.localhost:8443` if Traefik is running

## Useful Adjustments

- Change `HOMARR_PORT` if port `80` is already taken.
- Set a real `SECRET_ENCRYPTION_KEY` and keep it stable across restarts.

## Quick Checks

```bash
curl -I http://127.0.0.1/
docker compose logs -f homarr
```

## Quick Debug Notes

- If Traefik routing works but local access does not, port `80` is the likely conflict.
- If widgets cannot see Docker state, confirm the socket mount is still present.
