# PostgreSQL

Stack oficial de banco compartilhado da raiz.

## Arquivos

- `docker-compose.yml`: PostgreSQL + bootstrap idempotente de bancos.
- `.env.example`: template local.
- `databases`: lista de bancos a criar no bootstrap.
- `scripts/bootstrap-litellm.sh`: cria roles e databases com segurança.
- `init/`: hooks de inicialização do container.

## Uso

```bash
cp .env.example .env
docker compose up -d
```

Para parar:

```bash
docker compose down
```

## Notas

- Esta stack cria a rede `database-network`.
- `db-bootstrap` lê `./databases` e aceita referências a variáveis do `.env`.
- O monitoramento coleta métricas via `postgres-exporter` usando `DATA_SOURCE_URI`, `DATA_SOURCE_USER` e `DATA_SOURCE_PASS`.
