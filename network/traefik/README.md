# Traefik + CrowdSec

Edge HTTP local com TLS, roteamento por hostname e proteção básica com CrowdSec/AppSec.

## Uso

```bash
cp .env.example .env
docker compose up -d
```

## Perfil de consumo

- `traefik`: `0.30 CPU`, `256 MB`
- `crowdsec`: `0.50 CPU`, `384 MB`

## Portas padrão

- `8088`: HTTP com redirecionamento para HTTPS
- `8443`: HTTPS
- `127.0.0.1:8089`: dashboard local do Traefik

## Hostnames prontos

- `https://traefik.localhost:8443`
- `https://site.localhost:8443`
- `https://homarr.localhost:8443`
- `https://openwebui.localhost:8443`
- `https://librechat.localhost:8443`
- `https://signoz.localhost:8443`
- `https://pihole.localhost:8443`
- `https://headscale.localhost:8443`

## Notas

- As rotas ficam em [dynamic/routes.yml](/home/oornnery/proj/self-hosted/network/traefik/dynamic/routes.yml) e apontam para as portas hoje já publicadas no host.
- Os middlewares do dashboard, headers e bouncer ficam em [dynamic/middlewares.yml](/home/oornnery/proj/self-hosted/network/traefik/dynamic/middlewares.yml).
- O dashboard do Traefik também fica exposto localmente em `127.0.0.1:8089`.
- As portas padrão são `8088/8443` para não colidir com o que já está rodando no host. Se você quiser usar `80/443`, ajuste [.env.example](/home/oornnery/proj/self-hosted/network/traefik/.env.example) e libere essas portas.
- O middleware do CrowdSec fica em modo `stream`, que é o caminho mais barato no hot path.
- Se você trocar `CROWDSEC_TRAEFIK_BOUNCER_KEY`, atualize também a chave em [dynamic/middlewares.yml](/home/oornnery/proj/self-hosted/network/traefik/dynamic/middlewares.yml).
