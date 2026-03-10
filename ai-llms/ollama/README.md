# Ollama

Local model runtime for the AI stacks.

## What This Stack Assumes

- `ai-llms-network` exists or will be created manually.
- You have enough RAM for the models you plan to load.
- `open-web-ui` and `liteLLM` will reach this service as `ollama`.

## Quick Start

```bash
cp .env.example .env
docker network inspect ai-llms-network >/dev/null 2>&1 || docker network create ai-llms-network
docker compose config
docker compose up -d
docker compose ps
```

## Host Access

- `http://localhost:11434`

## Useful Adjustments

- Set `OLLAMA_UID` and `OLLAMA_GID` if you need different file ownership on the host.
- Change `OLLAMA_PORT` if `11434` is already in use.
- Increase the memory limit in `docker-compose.yml` if you plan to load heavier models.

## Quick Checks

```bash
curl -s http://127.0.0.1:11434/api/tags
docker exec ollama ollama list
docker compose logs -f ollama
```

## Quick Debug Notes

- If the API is up but models fail to load, the usual cause is memory pressure, not networking.
- If downloads fail or the model directory is empty, check the container user mapping and host storage permissions.
