# Headscale

Control plane privado para clientes Tailscale.

## Uso

```bash
cp .env.example .env
docker compose up -d
```

## Perfil de consumo

- `headscale`: `0.25 CPU`, `192 MB`

## Acesso padrão

- API local: `http://127.0.0.1:8081`
- Via Traefik: `https://headscale.localhost:8443`

## Primeiros comandos

```bash
docker exec -it headscale headscale users create default
docker exec -it headscale headscale preauthkeys create --user default --reusable --expiration 24h
```

## Notas

- O `server_url` padrão está em [config.yaml](/home/oornnery/proj/self-hosted/network/headscale/config/config.yaml) e usa `headscale.localhost:8443`.
- Para uso real fora da máquina local, troque o domínio/porta no [config.yaml](/home/oornnery/proj/self-hosted/network/headscale/config/config.yaml) antes de registrar clientes.
- O DERP embutido ficou desligado para economizar recursos; por padrão o Headscale usa o DERP map público do Tailscale.
