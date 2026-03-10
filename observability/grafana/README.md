# Grafana

Stack de backup com Grafana provisionado para consumir o Prometheus backup.

## Uso

```bash
cp .env.example .env
docker compose up -d
```

## Perfil de consumo

- `grafana`: `0.25 CPU`, `256 MB`

## Notas

- A datasource padrão aponta para `PROMETHEUS_URL`, com default `http://host.docker.internal:9090`.
- O diretório `dashboards/` fica vazio por padrão, pronto para importação manual quando precisar.
