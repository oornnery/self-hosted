# 🏗️ Plano de Reorganização da Infraestrutura

## 🎯 Objetivo
Reorganizar a estrutura de diretórios para comportar melhor as expansões futuras, mantendo categorias lógicas e facilitando o gerenciamento.

## 📊 Estrutura Atual vs Proposta

### 🔄 Estrutura Atual
```
self-hosted/
├── homarr/                 # Dashboard isolado
├── llms/                   # LLMs (OK, bem organizado)
├── monitoring/             # Monitoramento (OK, mas vai crescer)  
├── network/                # Rede (OK, mas vai crescer muito)
├── postgress/              # DB isolado
└── scripts/                # Scripts (OK)
```

### 🚀 Estrutura Proposta
```
self-hosted/
├── 🏠 dashboards/          # Centrais de controle
│   ├── homarr/             # Dashboard principal (MOVER)
│   └── [futuro: grafana-dashboards/]
├── 🤖 ai-llms/            # Inteligência Artificial (RENOMEAR)
│   ├── ollama/             # Mantém estrutura atual
│   ├── libre-chat/
│   ├── open-web-ui/
│   └── lite-llm/
├── 📊 observability/       # Observabilidade & Monitoramento (RENOMEAR + EXPANDIR)
│   ├── metrics/            # Métricas
│   │   ├── prometheus/     # MOVER de monitoring/
│   │   ├── grafana/        # MOVER de monitoring/
│   │   └── cadvisor/       # MOVER de monitoring/
│   ├── logs/               # Logs (PREPARAR PARA FUTURO)
│   │   └── [futuro: loki/, dozzle/, etc]
│   ├── tracing/            # Tracing (PREPARAR PARA FUTURO)
│   │   └── [futuro: beszel/, signoz/]
│   └── system-monitoring/  # Monitoramento de sistema (PREPARAR)
│       └── [futuro: netdata/, glances/]
├── 🔐 security/            # Segurança (NOVA CATEGORIA)
│   ├── network-protection/ # Proteção de rede
│   │   ├── pihole/         # MOVER de network/
│   │   └── [futuro: fail2ban/, crowdsec/, adguard/]
│   ├── auth/               # Autenticação (PREPARAR)
│   │   └── [futuro: vaultwarden/, 2fauth/]
│   ├── firewall/           # Firewall e WAF (PREPARAR)
│   │   └── [futuro: safeline/]
│   └── vpn-tunnels/        # VPN e túneis (PREPARAR)
│       ├── tailscale/      # MOVER de network/
│       └── [futuro: zrok/]
├── 🌐 networking/          # Rede e Conectividade (RENOMEAR + REORGANIZAR)
│   ├── proxy/              # Proxy Reverso (PREPARAR)
│   │   └── [futuro: traefik/, nginx/]
│   ├── dns/                # DNS já movido para security/
│   └── utilities/          # Utilitários de rede (PREPARAR)
│       └── [futuro: webhook-site/, dumbwhois/]
├── 💾 databases/           # Bancos de Dados (RENOMEAR + EXPANDIR)
│   ├── postgres/           # MOVER + RENOMEAR postgress/
│   ├── cache/              # Cache (PREPARAR)
│   │   └── [futuro: redis/, memcached/]
│   └── [futuro: outros DBs conforme necessário]
├── 🔄 automation/          # Automação (NOVA CATEGORIA)
│   ├── workflows/          # Workflows (PREPARAR)
│   │   └── [futuro: n8n/]
│   ├── home-automation/    # Casa inteligente (PREPARAR)
│   │   └── [futuro: home-assistant/]
│   ├── scraping/           # Web scraping (PREPARAR)
│   │   └── [futuro: scraperr/, maxun/]
│   └── backup/             # Backup e sync (PREPARAR)
│       └── [futuro: syncthing/, rclone/, ente/]
├── 🎬 media/               # Mídia e Entretenimento (NOVA CATEGORIA)
│   ├── servers/            # Servidores de mídia (PREPARAR)
│   │   └── [futuro: jellyfin/, plex/]
│   ├── streaming/          # Streaming (PREPARAR)
│   │   └── [futuro: ersatztv/, tunarr/]
│   ├── management/         # Gerenciamento (PREPARAR)
│   │   └── [futuro: riven/, watchstate/]
│   ├── clients/            # Clientes (PREPARAR)
│   │   └── [futuro: fladder/]
│   └── podcasts/           # Podcasts (PREPARAR)
│       └── [futuro: pinepods/]
├── 📝 productivity/        # Produtividade (NOVA CATEGORIA)
│   ├── collaboration/      # Colaboração (PREPARAR)
│   │   └── [futuro: penpot/, pad-ws/]
│   ├── documentation/      # Documentação (PREPARAR)
│   │   └── [futuro: scriberr/, snippets-library/]
│   ├── development/        # Desenvolvimento (PREPARAR)
│   │   └── [futuro: coder/, supabase/]
│   ├── finance/            # Finanças (PREPARAR)
│   │   └── [futuro: firefly-iii/]
│   └── personal/           # Pessoal (PREPARAR)
│       ├── [futuro: calendar/, immich/, localsend/]
│       └── [futuro: fitness/, communication/]
└── 🛠️ scripts/            # Scripts (MANTER ATUAL)
    ├── cli.sh              # Já dinâmico, vai funcionar
    ├── cp-env.sh
    └── [futuro: backup-scripts/, migration-scripts/]
```

## 🔧 Plano de Migração

### Fase 1: Reorganização Imediata (Sem Downtime)
```bash
# 1. Criar nova estrutura de diretórios
mkdir -p dashboards ai-llms observability/{metrics,logs,tracing,system-monitoring}
mkdir -p security/{network-protection,auth,firewall,vpn-tunnels}
mkdir -p networking/{proxy,utilities} databases/{postgres,cache}
mkdir -p automation/{workflows,home-automation,scraping,backup}
mkdir -p media/{servers,streaming,management,clients,podcasts}
mkdir -p productivity/{collaboration,documentation,development,finance,personal}

# 2. Mover serviços existentes (preservando .env e configs)
mv homarr/ dashboards/
mv llms/ ai-llms/
mv monitoring/ observability/metrics/
mv postgress/ databases/postgres/
mv network/pihole/ security/network-protection/
mv network/tailscale/ security/vpn-tunnels/
rmdir network/  # Se vazio
```

### Fase 2: Ajustes de Configuração
- Atualizar docker-compose.yml se necessário (redes, volumes)
- Testar script cli.sh (já é dinâmico, deve funcionar)
- Atualizar documentação

### Fase 3: Expansões Futuras
- Cada nova categoria já estará preparada
- Facilita a adição de serviços relacionados
- Melhor organização visual e lógica

## ✅ Vantagens da Nova Estrutura

1. **📊 Categorização Lógica**: Serviços agrupados por função
2. **🚀 Escalabilidade**: Fácil adição de novos serviços
3. **🔍 Navegação**: Mais intuitivo encontrar serviços
4. **🛠️ Manutenção**: Scripts continuam funcionando
5. **📚 Documentação**: Estrutura auto-explicativa
6. **🔄 Flexibilidade**: Subgrupos para organização detalhada

## 🎯 Próximos Passos

1. **Executar migração** (Fase 1)
2. **Testar funcionamento** de todos os serviços
3. **Atualizar README.md** com nova estrutura
4. **Preparar templates** para novos serviços
5. **Documentar padrões** de organização
