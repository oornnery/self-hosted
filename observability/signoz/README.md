# Monitoring

Stack oficial de observabilidade com SigNoz.

## O que sobe aqui

- Core do SigNoz: UI, ClickHouse, collector e migrator.
- Bridge on-prem: `postgres-exporter`, `otel-bridge` e `docker-log-forwarder`.

## Uso

```bash
cp .env.example .env
docker compose up -d
```

## Portas públicas

- `8080`: UI do SigNoz
- `4317`: OTLP gRPC
- `4318`: OTLP HTTP

## Notas

- Esta stack cria a rede `signoz-net`.
- `database-network` precisa existir antes, via [databases/postgres](/home/oornnery/proj/self-hosted/databases/postgres/README.md).
- O `otel-bridge` recebe OTLP das aplicações e encaminha para o collector interno do SigNoz.
- O forward de logs fica limitado aos containers listados em `FORWARD_CONTAINERS`.
