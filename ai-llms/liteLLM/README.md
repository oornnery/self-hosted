# LiteLLM

OpenAI-compatible gateway for the local AI stack.

## What This Stack Assumes

- [`databases/postgres`](../../databases/postgres/README.md) is already running.
- [`observability/signoz`](../../observability/signoz/README.md) is already running.
- `ai-llms-network` already exists.
- First boot can be slow because Prisma runs migrations and a schema sanity check.

## Quick Start

```bash
cp .env.example .env
docker compose config
docker compose up -d
docker compose ps
```

## Host Access

- `http://localhost:4000`

## Useful Adjustments

- Add or remove provider keys in `.env` depending on which backends you actually use.
- Keep `OTEL_ENDPOINT` pointed at `http://signoz-otel-collector:4318` unless your collector changes.
- Set `LITELLM_LOG=DEBUG` temporarily if you need more startup detail.
- Edit `litellm-config.yaml` to change routing, model aliases, or callbacks.

## Quick Checks

```bash
curl -fsS http://127.0.0.1:4000/health/liveliness
docker compose logs -f litellm
docker compose ps
```

## Quick Debug Notes

- A long `starting` state is normal on first boot. Watch the logs before changing healthchecks.
- If startup stalls on DB work, confirm the `postgres` container is healthy and reachable on `database-network`.
- If traces are missing, confirm the OTEL endpoint and that `signoz-otel-collector` is healthy.
