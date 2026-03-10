# Grafana Backup

Manual backup UI for the Prometheus backup stack.

## What This Stack Assumes

- Prometheus backup is already reachable.
- You want a separate dashboards UI but do not need it all the time.

## Quick Start

```bash
cp .env.example .env
docker compose config
docker compose up -d
docker compose ps
```

## Host Access

- `http://localhost:3001`

## Useful Adjustments

- Change `GRAFANA_PORT`, `GRAFANA_ADMIN_USER`, and `GRAFANA_ADMIN_PASSWORD` in `.env`.
- Change `PROMETHEUS_URL` if Prometheus is not on the default host port.
- Put imported dashboards under `dashboards/` when you need them.

## Quick Checks

```bash
curl -fsS http://127.0.0.1:3001/api/health
docker compose logs -f grafana
```

## Quick Debug Notes

- If Grafana loads but shows no data, check `PROMETHEUS_URL` first.
- The default provisioning only creates the datasource. Dashboards are intentionally manual.
