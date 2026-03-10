# Self-Hosted

Infra pessoal organizada por categorias, com a raiz como fonte de verdade.

## Stacks ativas

- [databases/postgres](/home/oornnery/proj/self-hosted/databases/postgres/README.md): PostgreSQL compartilhado + bootstrap de bancos.
- [observability/signoz](/home/oornnery/proj/self-hosted/observability/signoz/README.md): SigNoz oficial-enxuto + bridge OTEL.
- [network/traefik](/home/oornnery/proj/self-hosted/network/traefik/README.md): edge HTTP local com TLS e CrowdSec.
- [network/headscale](/home/oornnery/proj/self-hosted/network/headscale/README.md): control plane privado para clientes Tailscale.
- [network/pihole](/home/oornnery/proj/self-hosted/network/pihole/README.md): DNS local com Pi-hole + Unbound.
- [apps/site](/home/oornnery/proj/self-hosted/apps/site/README.md): site FastAPI publicado em GHCR com OTEL para SigNoz.
- [ai-llms/ollama](/home/oornnery/proj/self-hosted/ai-llms/ollama/README.md): modelos locais.
- [ai-llms/liteLLM](/home/oornnery/proj/self-hosted/ai-llms/liteLLM/README.md): gateway central para clientes compatíveis.
- [ai-llms/open-web-ui](/home/oornnery/proj/self-hosted/ai-llms/open-web-ui/README.md): UI para Ollama.
- [ai-llms/libre-chat](/home/oornnery/proj/self-hosted/ai-llms/libre-chat/README.md): cliente web completo apontado para LiteLLM.
- [dashboards/homarr](/home/oornnery/proj/self-hosted/dashboards/homarr/README.md): dashboard.

## Ordem sugerida

Suba as stacks nesta ordem:

1. `databases/postgres`
2. `observability/signoz`
3. `network/pihole`
4. `network/headscale`
5. `apps/site`
6. `ai-llms/ollama`
7. `ai-llms/liteLLM`
8. `ai-llms/open-web-ui`
9. `ai-llms/libre-chat`
10. `dashboards/homarr`
11. `network/traefik`

Cada stack mantém seu próprio `.env.example`.

## Legado

- Todo o material antigo ou duplicado fica em `archive/`.
- O legado de `on-prem/` foi movido para `archive/on-prem/`.

## Backups manuais

- [observability/prometheus](/home/oornnery/proj/self-hosted/observability/prometheus/README.md): stack de backup com Prometheus, Blackbox Exporter, cAdvisor, Postgres Exporter e Alertmanager.
- [observability/grafana](/home/oornnery/proj/self-hosted/observability/grafana/README.md): stack de backup com Grafana provisionado para consumir o Prometheus backup.

## Opcional

- `network/traefik` pode ficar por último porque ele só faz a borda HTTP dos serviços que já estão publicados.
- `network/pihole` continua dependendo da porta `53` livre no host.
