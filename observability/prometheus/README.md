# Prometheus

Stack de backup com Prometheus, Blackbox Exporter, cAdvisor, Postgres Exporter e Alertmanager.

## Uso

```bash
cp .env.example .env
docker compose up -d
```

## O que monitora

- Saúde HTTP dos serviços publicados no host: `site`, `litellm`, `ollama`, `open-web-ui`, `librechat`, `homarr`, `signoz` e `pihole` quando estiver ativo.
- Métricas do PostgreSQL via `postgres-exporter`.
- Métricas de containers via `cAdvisor`.

## Perfil de consumo

- `prometheus`: `0.30 CPU`, `384 MB`
- `cadvisor`: `0.20 CPU`, `128 MB`
- `postgres-exporter`: `0.05 CPU`, `64 MB`
- `blackbox-exporter`: `0.05 CPU`, `64 MB`
- `alertmanager`: `0.05 CPU`, `64 MB`

## Notas

- O stack usa `host.docker.internal` para sondar as portas já publicadas no host e não depende de acoplar novas redes às aplicações.
- `database-network` precisa existir para o `postgres-exporter`.
