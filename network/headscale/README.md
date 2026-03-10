# Headscale

Private Tailscale control plane with a local-first default configuration.

## What This Stack Assumes

- You want a lightweight self-hosted control plane.
- The default config is for local use, not public internet use.
- Traefik is optional but supported.

## Quick Start

```bash
cp .env.example .env
docker compose config
docker compose up -d
docker compose ps
```

## Host Access

- `http://127.0.0.1:8081`
- `https://headscale.localhost:8443` if Traefik is running

## First Commands

```bash
docker exec -it headscale headscale users create default
docker exec -it headscale headscale preauthkeys create --user default --reusable --expiration 24h
docker exec -it headscale headscale nodes list
```

## Useful Adjustments

- Change the public URL in `config/config.yaml` before registering real clients.
- Review `config/acl.hujson` if you want stricter client isolation.
- Keep DERP disabled unless you explicitly want to run more infrastructure.

## Quick Checks

```bash
curl -I http://127.0.0.1:8081/
docker compose logs -f headscale
```

## Quick Debug Notes

- If clients cannot connect, check `server_url` in `config/config.yaml` first.
- If Traefik works but local access does not, inspect the bind port in `.env`.
