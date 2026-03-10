# Pi-hole + Unbound

DNS local com bloqueio de anúncios no Pi-hole e recursão local via Unbound.

## Uso

```bash
cp .env.example .env
docker compose up -d
```

## Perfil de consumo

- `pihole`: `0.25 CPU`, `256 MB`
- `unbound`: `0.10 CPU`, `128 MB`

## Notas

- O Pi-hole passa a usar `unbound#5335` como upstream.
- O DNS é publicado no IP definido em `.env` por `PIHOLE_BIND_IP`, evitando conflito com resolvedores locais presos no loopback.
- Por padrão a stack usa só DNS e web UI. DHCP não fica exposto para evitar conflito e reduzir superfície.
- A web UI continua em `http://localhost:8090/admin`.
- Se você realmente quiser DHCP pelo Pi-hole depois, reabra a porta `67/udp` e devolva a capability `NET_ADMIN`.
