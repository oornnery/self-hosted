# LibreChat

Cliente web completo apontado para o LiteLLM como gateway padrão.

## Uso

```bash
cp .env.example .env
docker compose up -d
```

## Notas

- O endpoint padrão em `librechat.yaml` é o `LiteLLM`.
- Apenas o serviço `api` entra na rede `ai-llms-network`.
- MongoDB, Meilisearch e pgvector continuam isolados na rede local desta stack.
