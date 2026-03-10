# Open WebUI

Web UI for Ollama on the shared AI network.

## What This Stack Assumes

- `ai-llms-network` already exists.
- Ollama is already running and reachable as `ollama`.
- First boot can take a while because the app initializes its local state.

## Quick Start

```bash
cp .env.example .env
docker compose config
docker compose up -d
docker compose ps
```

## Host Access

- `http://localhost:3000`
- `https://openwebui.localhost:8443` if Traefik is running

## Useful Adjustments

- Set a real `WEBUI_SECRET_KEY`.
- Change `OPEN_WEBUI_PORT` if `3000` is busy.
- Keep `OLLAMA_BASE_URL=http://ollama:11434` unless you intentionally move Ollama.

## Quick Checks

```bash
curl -I http://127.0.0.1:3000/
docker compose logs -f open-webui
```

## Quick Debug Notes

- If the UI loads but no models appear, test Ollama first.
- If health stays in `starting` for a while, give the container time before changing limits or probes.
