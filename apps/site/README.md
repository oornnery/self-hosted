# Site

Personal site container from `ghcr.io/oornnery/site`, with backend and frontend telemetry wired to SigNoz.

## What This Stack Assumes

- [`observability/signoz`](../../observability/signoz/README.md) is already running.
- `signoz-net` already exists.
- You want the app available both directly and through Traefik.

## Quick Start

```bash
cp .env.example .env
docker compose config
docker compose up -d
docker compose ps
```

## Host Access

- `http://localhost:8001`
- `https://site.localhost:8443` if Traefik is running

## Useful Adjustments

- Set `SITE_BASE_URL` and `SITE_TRUSTED_HOSTS` to match the real hostnames you use.
- Set `SITE_SECRET_KEY` before using the container outside local testing.
- Keep `SITE_OTEL_EXPORTER_OTLP_ENDPOINT` pointed at `signoz-otel-collector:4317` unless your collector changes.
- Leave `SITE_FRONTEND_TELEMETRY_OTLP_ENDPOINT` empty if you want the app to derive the browser OTLP target automatically.

## Quick Checks

```bash
curl -fsS http://127.0.0.1:8001/health
curl -k -I -H 'Host: site.localhost' https://127.0.0.1:8443/
docker compose logs -f site
```

## Quick Debug Notes

- If the app returns host validation errors, check `SITE_BASE_URL` and `SITE_TRUSTED_HOSTS`.
- If telemetry is missing, check the OTLP endpoint and confirm `signoz-otel-collector` is healthy.
- If the Traefik route works but local access does not, check `SITE_PORT`.
