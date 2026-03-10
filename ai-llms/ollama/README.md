# Ollama

Provedor local de modelos conectado na rede `ai-llms-network`.

## Uso

```bash
cp .env.example .env
docker network inspect ai-llms-network >/dev/null 2>&1 || docker network create ai-llms-network
docker compose up -d
```

## Notas

- Expõe a API em `11434` por padrão.
- Usa a rede compartilhada `ai-llms-network`.
- `Open WebUI` e `LiteLLM` consomem este serviço pelo hostname `ollama`.
