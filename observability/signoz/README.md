# SigNoz

Primary observability stack for this host. It handles traces, metrics, and selected Docker logs.

## What This Stack Assumes

- [`databases/postgres`](../../databases/postgres/README.md) is already up.
- This is the main observability path. Prometheus and Grafana are backup/manual stacks only.
- You are okay with low-resource defaults and limited Docker log forwarding.

## What Runs Here

- SigNoz UI
- ClickHouse
- ZooKeeper
- SigNoz OTLP collector
- Telemetry store migrator
- `postgres-exporter`
- `otel-bridge`
- `docker-log-forwarder`

## Quick Start

```bash
cp .env.example .env
docker compose config
docker compose up -d
docker compose ps
```

## Host Access

- `http://localhost:8080`
- `http://localhost:4317` for OTLP gRPC
- `http://localhost:4318` for OTLP HTTP
- `https://signoz.localhost:8443` if Traefik is running

## Useful Adjustments

- Edit `FORWARD_CONTAINERS` if you want more or fewer Docker logs ingested.
- Keep OTLP ports at `4317` and `4318` unless you also update application configs.
- If ClickHouse starts hitting memory pressure, increase the `clickhouse` memory limit before raising the rest of the stack.

## Quick Checks

```bash
curl -fsS http://127.0.0.1:8080/api/v1/health
docker compose ps
docker compose logs -f signoz
docker compose logs -f signoz-otel-collector
docker compose logs -f otel-bridge
```

## Quick Debug Notes

- `otel-bridge` is the place to check if app OTLP data or forwarded container logs are missing.
- `docker-log-forwarder` only tails containers listed in `FORWARD_CONTAINERS`.
- Some startup delay is normal because ClickHouse, migrations, and the internal collector come up in sequence.
