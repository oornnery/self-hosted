# Prometheus Backup

Manual backup metrics stack. Use it only when you want a Prometheus-based view in addition to SigNoz.

## What This Stack Assumes

- [`databases/postgres`](../../databases/postgres/README.md) already exists.
- The target services expose host ports that Prometheus can probe through `host.docker.internal`.
- This stack is not required for the normal host flow.

## Quick Start

```bash
cp .env.example .env
docker compose config
docker compose up -d
docker compose ps
```

## Host Access

- `http://localhost:9090`
- `http://localhost:9093`

## Useful Adjustments

- Change retention with `PROMETHEUS_RETENTION_TIME` and `PROMETHEUS_RETENTION_SIZE`.
- Update probe targets in `prometheus.yml` if host ports change.
- Keep `DATA_SOURCE_*` aligned with the PostgreSQL stack.

## Quick Checks

```bash
curl -fsS http://127.0.0.1:9090/-/healthy
curl -fsS http://127.0.0.1:9093/-/healthy
docker compose logs -f prometheus
```

## Quick Debug Notes

- If host probes fail, check the published port on the target stack first.
- If PostgreSQL metrics fail, check `database-network` and the `postgres-exporter` environment.
