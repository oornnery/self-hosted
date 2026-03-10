# Self-Hosted Host Guide

This repository is the single source of truth for the active host. Each stack is self-contained, uses its own `.env.example`, and is operated directly with `docker compose` from its own directory. There are no repo-level helper scripts by design.

## Host Profile

- Docker Engine with Docker Compose v2 is required.
- The stack is tuned for a low-resource host by default. Most services already have `cpus`, `mem_limit`, and log rotation configured in their compose files.
- `.env` files are local runtime files and are ignored by Git. Commit only `.env.example`.
- `archive/` contains legacy layouts and backups. It is not part of the active host.

## Repository Layout

- [`databases/postgres`](databases/postgres/README.md): shared PostgreSQL and idempotent bootstrap.
- [`observability/signoz`](observability/signoz/README.md): primary observability stack.
- [`network/pihole`](network/pihole/README.md): DNS and ad blocking with Unbound recursion.
- [`network/headscale`](network/headscale/README.md): private Tailscale control plane.
- [`network/traefik`](network/traefik/README.md): local edge, TLS, and CrowdSec.
- [`apps/site`](apps/site/README.md): personal site container from GHCR.
- [`ai-llms/ollama`](ai-llms/ollama/README.md): local model runtime.
- [`ai-llms/liteLLM`](ai-llms/liteLLM/README.md): OpenAI-compatible gateway.
- [`ai-llms/open-web-ui`](ai-llms/open-web-ui/README.md): UI for Ollama.
- [`ai-llms/libre-chat`](ai-llms/libre-chat/README.md): full chat UI routed through LiteLLM.
- [`dashboards/homarr`](dashboards/homarr/README.md): lightweight home dashboard.
- [`observability/prometheus`](observability/prometheus/README.md): manual backup metrics stack.
- [`observability/grafana`](observability/grafana/README.md): manual backup UI for the backup Prometheus stack.

## Active Stack Catalog

| Stack | Role | Main Host Access | Notes |
| --- | --- | --- | --- |
| [`databases/postgres`](databases/postgres/README.md) | Shared PostgreSQL | Internal only on `database-network` | Start first |
| [`observability/signoz`](observability/signoz/README.md) | Main telemetry and logs | `8080`, `4317`, `4318`, `signoz.localhost:8443` | Creates `signoz-net` |
| [`network/pihole`](network/pihole/README.md) | DNS and ad blocking | `${PIHOLE_BIND_IP}:53`, `8090`, `pihole.localhost:8443` | DNS bind IP must match a real host interface |
| [`network/headscale`](network/headscale/README.md) | Private VPN control plane | `127.0.0.1:8081`, `headscale.localhost:8443` | Local-first default domain |
| [`apps/site`](apps/site/README.md) | Personal site | `8001`, `site.localhost:8443` | Sends OTEL telemetry to SigNoz |
| [`ai-llms/ollama`](ai-llms/ollama/README.md) | Local model runtime | `11434` | Uses `ai-llms-network` |
| [`ai-llms/liteLLM`](ai-llms/liteLLM/README.md) | LLM gateway | `4000` | Depends on Postgres and SigNoz |
| [`ai-llms/open-web-ui`](ai-llms/open-web-ui/README.md) | Ollama UI | `3000`, `openwebui.localhost:8443` | Talks to `ollama` over `ai-llms-network` |
| [`ai-llms/libre-chat`](ai-llms/libre-chat/README.md) | Chat frontend | `3080`, `librechat.localhost:8443` | Uses LiteLLM as upstream |
| [`dashboards/homarr`](dashboards/homarr/README.md) | Home dashboard | `80`, `homarr.localhost:8443` | Port `80` must be free on the host |
| [`network/traefik`](network/traefik/README.md) | Local edge and TLS | `8088`, `8443`, `127.0.0.1:8089` | Start last |

## Manual Backup Stacks

| Stack | Role | Main Host Access |
| --- | --- | --- |
| [`observability/prometheus`](observability/prometheus/README.md) | Backup metrics stack | `9090`, `9093` |
| [`observability/grafana`](observability/grafana/README.md) | Backup dashboards | `3001` |

These are not the primary observability path. The active path is SigNoz.

## Networks

- `database-network`: shared internal network for PostgreSQL consumers.
- `signoz-net`: observability network created by the SigNoz stack.
- `ai-llms-network`: shared network for Ollama, LiteLLM, Open WebUI, and the LibreChat API.

`ai-llms-network` is external in the AI stacks, so create it once before starting those stacks if it does not already exist:

```bash
docker network inspect ai-llms-network >/dev/null 2>&1 || docker network create ai-llms-network
```

## First-Time Setup

1. Copy `.env.example` to `.env` inside each stack directory you plan to run.
2. Adjust secrets, ports, and host-specific values before starting anything.
3. If you want the full active host, start the stacks in this order:

```text
databases/postgres
observability/signoz
network/pihole
network/headscale
apps/site
ai-llms/ollama
ai-llms/liteLLM
ai-llms/open-web-ui
ai-llms/libre-chat
dashboards/homarr
network/traefik
```

4. Start each stack from its own directory:

```bash
docker compose config
docker compose up -d
docker compose ps
```

## Day-to-Day Commands

Run these from the stack directory you are working on:

```bash
docker compose config
docker compose up -d
docker compose ps
docker compose logs -f
docker compose restart <service>
docker compose down
```

Useful host-level commands:

```bash
docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
docker network ls
docker volume ls
docker inspect <container>
```

## Documentation Checks

Run these from the repository root when you update Markdown files:

```bash
uv run rumdl check . && uv run rumdl fmt .
```

## Quick Health Checks

```bash
curl -fsS http://127.0.0.1:8080/api/v1/health
curl -fsS http://127.0.0.1:4000/health/liveliness
curl -fsS http://127.0.0.1:8001/health
curl -s http://127.0.0.1:11434/api/tags
curl -I http://127.0.0.1:3080/
curl -I http://127.0.0.1:8090/admin/
curl http://127.0.0.1:8089/ping
```

Traefik routes can be checked with host headers:

```bash
curl -k -I -H 'Host: site.localhost' https://127.0.0.1:8443/
curl -k -I -H 'Host: signoz.localhost' https://127.0.0.1:8443/
curl -k -I -H 'Host: librechat.localhost' https://127.0.0.1:8443/
```

## Useful Host Adjustments

- Change exposed ports by editing the local `.env` for each stack.
- Change DNS binding for Pi-hole with `PIHOLE_BIND_IP`.
- Change Traefik edge ports with `TRAEFIK_HTTP_PORT`, `TRAEFIK_HTTPS_PORT`, and `TRAEFIK_DASHBOARD_PORT`.
- Extend SigNoz Docker log capture by editing `FORWARD_CONTAINERS` in [`observability/signoz/.env.example`](observability/signoz/.env.example).
- Increase resource limits only where needed. The main hot spots are `signoz-clickhouse`, `ollama`, `open-web-ui`, `librechat-api`, and `litellm`.
- For real Headscale usage, update [`network/headscale/config/config.yaml`](network/headscale/config/config.yaml) before registering clients.

## Quick Debug Guide

### If a service is up but not reachable

- Check the stack status: `docker compose ps`
- Check the container logs: `docker compose logs -f <service>`
- Check the host port binding: `docker ps --format 'table {{.Names}}\t{{.Ports}}'`

### If a service cannot reach PostgreSQL

- Confirm `postgres` is healthy.
- Confirm the service is attached to `database-network`.
- Confirm credentials in the local `.env` match the bootstrap values.

### If telemetry or logs are missing in SigNoz

- Check `signoz-otel-collector`, `otel-bridge`, and `docker-log-forwarder`.
- Confirm the app is using `signoz-otel-collector:4317` or `:4318`.
- Confirm the container name is listed in `FORWARD_CONTAINERS` if you expect Docker log forwarding.

### If Traefik routes fail

- Check `network/traefik/dynamic/routes.yml`.
- Confirm the backend port is already published on the host.
- Confirm `traefik` and `crowdsec` are both healthy.

### If Pi-hole fails to start

- Confirm the chosen `PIHOLE_BIND_IP` exists on the host.
- Confirm port `53` on that IP is not already in use.
- Check `unbound` first. Pi-hole depends on it.

### If LiteLLM stays in `starting`

- This can be normal on first boot because Prisma migrations and schema sanity checks can take a while.
- Watch `docker logs litellm-proxy -f` before assuming the container is broken.

## Legacy and Cleanup

- `archive/` keeps old layouts and reference material.
- Old runtime resources should be cleaned only after the replacement stack is confirmed healthy.
- The current active runtime has already been migrated away from the old `on-prem` layout.
