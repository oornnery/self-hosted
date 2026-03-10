# LiteLLM

Gateway principal dos clientes compatíveis com OpenAI.

## Dependências

- [PostgreSQL](/home/oornnery/proj/self-hosted/databases/postgres/README.md)
- [Monitoring](/home/oornnery/proj/self-hosted/observability/monitoring/README.md)
- [Ollama](/home/oornnery/proj/self-hosted/ai-llms/ollama/README.md) para modelos locais

## Uso

```bash
cp .env.example .env
docker compose up -d
```

## Notas

- Conecta em `database-network`, `signoz-net` e `ai-llms-network`.
- Publica a API na porta definida por `LITELLM_PORT`.
- O healthcheck usa a rota real `/health/liveliness`, sem depender de `curl`.
- A configuração em `litellm-config.yaml` já inclui callbacks OTEL para traces no SigNoz.
