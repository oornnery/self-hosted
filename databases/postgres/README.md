# PostgreSQL

Shared PostgreSQL for the host. This is the first stack to start because SigNoz and LiteLLM depend on it.

## What This Stack Assumes

- Docker Compose v2 is available.
- You want one shared database service for multiple stacks.
- The database is internal only. No host port is published.

## Important Files

- `docker-compose.yml`: PostgreSQL plus the one-shot bootstrap container.
- `.env.example`: local template for credentials.
- `databases`: list of databases to create during bootstrap.
- `scripts/bootstrap-litellm.sh`: idempotent role and database bootstrap logic.
- `init/`: container init hooks.

## Quick Start

```bash
cp .env.example .env
docker compose config
docker compose up -d
docker compose ps
```

## What It Creates

- Container: `postgres`
- One-shot helper: `db-bootstrap`
- Shared network: `database-network`

## Useful Adjustments

- Change `POSTGRES_USER`, `POSTGRES_PASSWORD`, and `POSTGRES_DB` in `.env`.
- Add or remove logical databases in `databases`.
- Keep `DATA_SOURCE_*` aligned if you want metrics collected by SigNoz or Prometheus.

## Quick Checks

```bash
docker compose logs -f postgres
docker exec postgres pg_isready -U master -d master
docker exec postgres psql -U master -lqt
```

## Quick Debug Notes

- If `db-bootstrap` exits with an error, check the `databases` file and the credentials in `.env`.
- If another stack cannot resolve `postgres`, confirm it is attached to `database-network`.
- If you need more headroom, increase `cpus` or `mem_limit` in `docker-compose.yml`.
