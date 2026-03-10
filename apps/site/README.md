# Site

Stack do site publicado em `ghcr.io/oornnery/site`.

## Uso

```bash
cp .env.example .env
docker compose up -d
```

## Integração com SigNoz

- O backend usa `OTEL_*` como fonte de verdade.
- `OTEL_EXPORTER_OTLP_ENDPOINT=http://signoz-otel-collector:4317` envia a telemetria do app direto para o collector interno do SigNoz.
- O frontend continua usando `POST /otel/v1/traces` no próprio app.
- Com `FRONTEND_TELEMETRY_OTLP_ENDPOINT` vazio, o app deriva o collector HTTP a partir do endpoint OTLP do backend e encaminha os spans para `4318/v1/traces`.

## Notas

- Esta stack assume que `observability/signoz` já criou a rede `signoz-net`.
- O upstream publica dashboards e manifests do SigNoz no repositório do site, em `infra/signoz`.
