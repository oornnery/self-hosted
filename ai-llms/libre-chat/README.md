# LibreChat

Full chat UI that uses LiteLLM as the default model gateway.

## What This Stack Assumes

- LiteLLM is already up and reachable as `litellm-proxy`.
- `ai-llms-network` already exists.
- You are okay with a self-contained stack for MongoDB, Meilisearch, pgvector, and the RAG API.

## Quick Start

```bash
cp .env.example .env
docker compose config
docker compose up -d
docker compose ps
```

## Host Access

- `http://localhost:3080`
- `https://librechat.localhost:8443` if Traefik is running

## Useful Adjustments

- Set `LITELLM_BASE_URL` and `LITELLM_API_KEY` to match your LiteLLM runtime.
- Change `DOMAIN_CLIENT` and `DOMAIN_SERVER` if the app is exposed on a real domain.
- Disable `ALLOW_REGISTRATION` if this should not be open to new users.
- Adjust `librechat.yaml` if you want to change the visible provider layout.

## Quick Checks

```bash
curl -I http://127.0.0.1:3080/
docker compose logs -f api
docker compose logs -f rag_api
```

## Quick Debug Notes

- If the UI loads but models fail, test LiteLLM first.
- Only the `api` service joins `ai-llms-network`. The rest stay internal to this stack.
- If search or file features fail, check `meilisearch`, `vectordb`, and `rag_api` separately.
