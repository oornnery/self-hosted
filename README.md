# 🏠 Self-Hosted Infra: Stack Docker Modular

Infraestrutura pessoal, modular e expansível, baseada em Docker Compose, com foco em automação, monitoramento, privacidade e produtividade.

## 📑 Sumário

- [Visao Geral](#visao-geral)
- [Tabela de Servicos](#tabela-de-servicos)
- [Inicio Rapido](#inicio-rapido)
- [Configuracao](#configuracao)
- [Gerenciamento](#gerenciamento)
- [Portas dos Servicos](#portas-dos-servicos)
- [Monitoramento](#monitoramento)
- [Seguranca](#seguranca)
- [Troubleshooting](#troubleshooting)
- [Roadmap & Expansoes Futuras](#roadmap-e-expansoes-futuras)
- [Stack de Midia Recomendada](#destaque-ecossistema-de-midia-completo)
- [Notas](#notas)

---

## 🌟 Visão Geral

Projeto para centralizar serviços essenciais (LLMs, monitoramento, rede, mídia, automação, etc.) de forma simples, segura e escalável.

---

## 📋 Tabela de Serviços

| Serviço        | Categoria      | Porta(s) | Status         |
| -------------- | -------------- | -------- | -------------- |
| **Homarr**     | Dashboard      | 80       | ✅ Configurado |
| **Grafana**    | Monitoramento  | 3001     | ✅ Configurado |
| **Prometheus** | Monitoramento  | 9100     | ✅ Configurado |
| **cAdvisor**   | Monitoramento  | 8080     | ✅ Configurado |
| **Pi-hole**    | Rede/Segurança | 8090     | ✅ Configurado |
| **LibreChat**  | LLMs/IA        | 3080     | ✅ Configurado |
| **Open-WebUI** | LLMs/IA        | 3000     | ✅ Configurado |
| **LiteLLM**    | LLMs/IA        | 4000     | ✅ Configurado |
| **Ollama**     | LLMs/IA        | 11434    | ✅ Configurado |
| **PostgreSQL** | Banco de Dados | 5432     | ✅ Configurado |

---

## 🗂️ Estrutura do Projeto {#estrutura-do-projeto}

```bash
self-hosted/
├── 📊 monitoring/           # Stack de monitoramento
│   ├── prometheus/          # Métricas e alertas
│   ├── grafana/            # Dashboards e visualização
│   └── cAdvisor/           # Monitoramento de containers
├── 🤖 llms/                # Modelos de linguagem
│   ├── ollama/             # LLM local
│   ├── libre-chat/         # Interface web para LLMs
│   ├── open-web-ui/        # UI alternativa para Ollama
│   └── lite-llm/           # Proxy para múltiplos LLMs
├── 🌐 network/             # Serviços de rede
│   ├── pihole/             # DNS + Ad-blocker
│   └── tailscale/          # VPN mesh (configuração futura)
├── 🏠 homarr/              # Dashboard centralizado
├── 💾 postgress/           # Banco de dados PostgreSQL
└── 🛠️ scripts/            # Scripts de automação
    ├── cli.sh       # Gerenciamento de todos os stacks
    └── cp-env.sh           # Copia arquivos .env.example
```

## 🚀 Serviços Disponíveis {#servicos-disponiveis}

### 🤖 LLMs (Large Language Models)

| Serviço        | Descrição                                 | Porta | Status         |
| -------------- | ----------------------------------------- | ----- | -------------- |
| **Ollama**     | Execução local de LLMs                    | 11434 | ✅ Configurado |
| **LibreChat**  | Interface web completa para LLMs          | 3080  | ✅ Configurado |
| **Open-WebUI** | UI alternativa para Ollama                | 3000  | ✅ Configurado |
| **LiteLLM**    | Proxy unificado para múltiplos provedores | 4000  | ✅ Configurado |

### 📊 Monitoramento

| Serviço           | Descrição                   | Porta | Status         |
| ----------------- | --------------------------- | ----- | -------------- |
| **Prometheus**    | Coleta de métricas          | 9100  | ✅ Configurado |
| **Grafana**       | Dashboards e visualização   | 3001  | ✅ Configurado |
| **cAdvisor**      | Monitoramento de containers | 8080  | ✅ Configurado |
| **Node Exporter** | Métricas do sistema         | 9101  | ✅ Configurado |
| **AlertManager**  | Gerenciamento de alertas    | 9102  | ✅ Configurado |

### 🌐 Rede

| Serviço       | Descrição        | Porta                | Status         |
| ------------- | ---------------- | -------------------- | -------------- |
| **Pi-hole**   | DNS + Ad-blocker | 8090 (web), 53 (DNS) | ✅ Configurado |
| **Tailscale** | VPN mesh         | -                    | 🚧 Futuro      |

### 🏠 Outros Serviços

| Serviço        | Descrição              | Porta | Status         |
| -------------- | ---------------------- | ----- | -------------- |
| **Homarr**     | Dashboard centralizado | 80    | ✅ Configurado |
| **PostgreSQL** | Banco de dados         | 5432  | ✅ Configurado |

## 🚀 Início Rápido {#inicio-rapido}

### 1. Pré-requisitos

```bash
# Instalar Docker e Docker Compose
sudo pacman -Sy docker docker-compose
sudo usermod -aG docker $USER
```

### 2. Configuração Inicial

```bash
# Clonar/baixar o projeto
cd /home/oornnery/self-hosted

# Copiar arquivos de configuração
./scripts/cp-env.sh

# Revisar e ajustar configurações nos arquivos .env
```

### 3. Iniciar Todos os Serviços

```bash
# Iniciar toda a stack
./scripts/cli.sh up

# OU iniciar serviços específicos
cd monitoring/prometheus && docker compose up -d
cd ../../llms/ollama && docker compose up -d
```

## ⚙️ Configuração {#configuracao}

### Variáveis de Ambiente

Cada serviço possui um arquivo `.env.example` que deve ser copiado para `.env` e customizado:

```bash
# Automaticamente copia todos os .env.example para .env
./scripts/cp-env.sh
```

### Configurações Importantes

#### 🔑 Senhas e Chaves

- **Grafana**: `GRAFANA_PASSWORD` em `monitoring/grafana/.env`
- **Pi-hole**: `WEBPASSWORD` em `network/pihole/.env`
- **LiteLLM**: `LITELLM_MASTER_KEY` em `llms/lite-llm/.env`
- **LibreChat**: Múltiplas chaves em `llms/libre-chat/.env`

#### 🌐 APIs Externas

- **OpenRouter**: `OPENROUTER_API_KEY` para LiteLLM e LibreChat
- Configure em `llms/lite-llm/.env` e `llms/libre-chat/.env`

#### 🐘 PostgreSQL

- Usado pelo LiteLLM para persistência
- Configuração em `postgress/.env`

## 🛠️ Gerenciamento {#gerenciamento}

### Scripts Disponíveis

```bash
# ===== GERENCIAMENTO GERAL =====
# Iniciar todos os serviços
./scripts/cli.sh
# ou
./scripts/cli.sh up

# Parar todos os serviços (mantém volumes)
./scripts/cli.sh down

# Parar e remover tudo (incluindo volumes anônimos)
./scripts/cli.sh rm

# ===== SERVIÇOS ESPECÍFICOS =====
# Iniciar serviços individuais
./scripts/cli.sh start postgres
./scripts/cli.sh up llms/ollama
./scripts/cli.sh start homarr network/pihole

# Parar serviços específicos
./scripts/cli.sh stop postgres
./scripts/cli.sh down llms/ollama monitoring/grafana

# ===== MONITORAMENTO =====
# Listar todos os serviços disponíveis
./scripts/cli.sh list

# Ver status de todos os containers
./scripts/cli.sh status

# Ver ajuda completa
./scripts/cli.sh help

# ===== CONFIGURAÇÃO =====
# Copiar arquivos .env.example
./scripts/cp-env.sh
```

#### 📋 **Como Funciona**

O script agora é **totalmente dinâmico** e **simples**:

- 🔍 **Descoberta automática**: Encontra todos os `docker-compose.yml` em qualquer estrutura de pastas
- 📁 **Suporte completo**: Funciona com pastas simples (`homarr/`) ou aninhadas (`llms/ollama/`)
- 🎯 **Sem configuração**: Não precisa editar o script ao adicionar novos serviços
- 🚀 **Flexível**: Inicie todos os serviços ou apenas os que você especificar

### Comandos Docker Compose

```bash
# Iniciar um serviço específico
cd llms/ollama
docker compose up -d

# Ver logs
docker compose logs -f

# Parar serviço
docker compose down

# Reconstruir imagens
docker compose up -d --build
```

## 🔌 Portas dos Serviços {#portas-dos-servicos}

### Acesso Web Principal

- **Homarr Dashboard**: <http://localhost:80>
- **Grafana**: <http://localhost:3001>
- **Pi-hole Admin**: <http://localhost:8090/admin>

### LLMs

- **LibreChat**: <http://localhost:3080>
- **Open-WebUI**: <http://localhost:3000>
- **LiteLLM**: <http://localhost:4000>

### APIs e Monitoramento

- **Ollama API**: <http://localhost:11434>
- **Prometheus**: <http://localhost:9100>
- **cAdvisor**: <http://localhost:8080>

### Bancos de Dados

- **PostgreSQL**: localhost:5432

## 📊 Monitoramento {#monitoramento}

### Stack Completa

- **Prometheus**: Coleta métricas de todos os serviços
- **Grafana**: Dashboards pré-configurados
- **cAdvisor**: Métricas específicas de containers
- **Node Exporter**: Métricas do sistema host

### Configuração de Rede

- Rede interna `monitoring` conecta todos os serviços
- AlertManager configurado (atualmente sem notificações)

## 🔒 Segurança {#seguranca}

### Boas Práticas Implementadas

- **Ollama**: Container em modo read-only, sem privilégios
- **Pi-hole**: Capabilities mínimas
- **Redes internas**: Isolamento entre serviços
- **Volumes nomeados**: Persistência segura de dados

### Recomendações

1. **Altere senhas padrão**: Todos os arquivos `.env`
2. **Configure firewall**: Restrinja acesso às portas
3. **Backup regular**: Scripts automáticos recomendados
4. **SSL/TLS**: Configure proxy reverso (Nginx/Traefik)

## 🩺 Troubleshooting {#troubleshooting}

### Problemas Comuns

#### Serviços não iniciam

```bash
# Verificar logs
docker compose logs serviço_name

# Verificar status
docker compose ps

# Recriar containers
docker compose down && docker compose up -d
```

#### Erro de permissões

```bash
# Verificar owner dos volumes
docker volume inspect volume_name

# Ajustar UID/GID no Ollama
# Verificar OLLAMA_UID e OLLAMA_GID no .env
```

#### Problemas de rede

```bash
# Criar rede do monitoramento se não existir
docker network create monitoring

# Verificar redes
docker network ls
```

#### PostgreSQL não conecta

```bash
# Verificar se o container está rodando
docker ps | grep postgres

# Testar conexão
docker exec -it postgres psql -U litellm_user -d litellm_db
```

### Logs e Debug

```bash
# Logs de todos os serviçoss
./scripts/cli.sh down && ./scripts/cli.sh up

# Logs específicos
cd monitoring/prometheus
docker compose logs -f prometheus

# Debug de um container
docker exec -it container_name /bin/bash
```

## 📈 Roadmap e Expansões Futuras

### 🚀 **Prioridade Alta** (Complementa stack atual)

#### 📊 **Monitoramento, Logs e Observabilidade**

- [ ] **[Netdata](https://www.netdata.cloud/)** - Monitoramento em tempo real (complementa Grafana)
- [ ] **[Grafana Loki](https://grafana.com/oss/loki/)** - Agregação de logs centralizada
- [ ] **[Dozzle](https://dozzle.dev/)** - Visualizador de logs Docker simples
- [ ] **[Speedtest Tracker](https://docs.speedtest-tracker.dev/)** - Monitoramento de velocidade da internet
- [ ] **[SigNoz](https://signoz.io/?ref=selfh.st)** - Observabilidade open-source (alternativa ao Grafana/Prometheus)
- [ ] **[Glances](https://nicolargo.github.io/glances/?ref=selfh.st)** - Monitoramento de sistema em tempo real
- [ ] **[Beszel](https://beszel.dev/guide/what-is-beszel)** - Observabilidade e tracing distribuído
- [ ] **Alternativas**: [Parseable](https://www.parseable.com/), [LogForge](https://www.logforge.dev/)

#### 🔐 **Segurança, Firewall e Rede**

- [ ] **[AdGuard Home](https://adguard.com/en/adguard-home/overview.html)** - Alternativa ao Pi-hole
- [ ] **[SafeLine](https://safepoint.cloud/landing/safeline)** - Web Application Firewall
- [ ] **[Fail2ban](https://github.com/fail2ban/fail2ban)** - Proteção contra brute force
- [ ] **[CrowdSec](https://www.crowdsec.net/?ref=selfh.st)** - Segurança colaborativa e proteção de serviços
- [ ] **[Vaultwarden](https://github.com/dani-garcia/vaultwarden)** - Gerenciador de senhas (Bitwarden self-hosted)
- [ ] **[2FAuth](https://docs.2fauth.app/)** - Autenticação de dois fatores
- [ ] **Tailscale** - VPN mesh (já planejado)
- [ ] **Proxy Reverso** - Traefik/Nginx com SSL automático
- [ ] **[zrok](https://zrok.io/)** - Túnel seguro e compartilhamento de serviços

- [ ] **Alternativa**: [Bitwarden oficial](https://bitwarden.com/)

#### 🔔 **Notificações, Webhooks e Utilidades**

- [ ] **[Webhook.site](http://webhook.site/)** - Teste e debug de webhooks
- [ ] **[DumbWhois](https://dumbwhois.dumbware.io/?ref=selfh.st)** - Consulta WHOIS simples via web

#### 💾 **Backup e Sincronização**

- [ ] **[Syncthing](https://syncthing.net/)** - Sincronização de arquivos P2P
- [ ] **[Rclone](https://rclone.org/)** - Backup para cloud storage
- [ ] **[Ente](https://ente.io/)** - Backup seguro de fotos e arquivos
- [ ] **Scripts de backup automatizado** para volumes Docker

### 🎯 **Prioridade Média** (Ferramentas produtivas)

#### 🏡 **Automação Residencial**

- [ ] **[Home Assistant](https://www.home-assistant.io/)** - Automação doméstica completa

#### 🔧 **Desenvolvimento e Automação**

- [ ] **[n8n](https://n8n.io/)** - Automação de workflows (complementa monitoramento)
- [ ] **[Coder](https://coder.com/)** - IDE na nuvem para desenvolvimento
- [ ] **[Supabase](https://supabase.com/)** - Backend as a Service (alternativa ao PostgreSQL+APIs)
- [ ] **[Maxun](https://www.maxun.dev/)** - Automação de tarefas web
- [ ] **[Scraperr](https://scraperr-docs.pages.dev/)** - Web scraping automatizado

#### 📝 **Colaboração e Documentação**

- [ ] **[Penpot](https://penpot.app/)** - Design colaborativo open-source
- [ ] **[Pad.ws](https://github.com/coderamp-labs/pad.ws)** - Editor colaborativo
- [ ] **[Snippets Library](https://snippetslibrary.com/)** - Gerenciador de código
- [ ] **[Scriberr](https://scriberr.app/)** - Sistema de notas e documentação

#### 💰 **Finanças Pessoais**

- [ ] **[Firefly III](https://firefly-iii.org/)** - Gerenciamento financeiro pessoal
- [ ] **[ezBookkeeping](https://github.com/mayswind/ezBookkeeping)** - Alternativa mais simples

#### 🎬 **Ecossistema de Mídia** (Nova categoria - complementa infraestrutura)

- [ ] **[ErsatzTV](https://ersatztv.org/)** - Cria canais de TV personalizados a partir da sua biblioteca
- [ ] **[Tunarr](https://tunarr.com/)** - Programação de TV automatizada (sucessor do ErsatzTV)
- [ ] **[Riven](https://rivenmedia.github.io/wiki/)** - Gerenciador completo de mídia com automação

### 🌟 **Prioridade Baixa** (Funcionalidades específicas)

#### 📅 **Agenda e Calendário**

- [ ] **[Cal.com](https://cal.com/)** - Sistema de agendamento

#### 📱 **Aplicativos Móveis e Desktop**

- [ ] **[LocalSend](https://localsend.org/pt-BR)** - Compartilhamento de arquivos local
- [ ] **[Immich](https://immich.app/)** - Galeria de fotos (alternativa ao Google Photos)
- [ ] **[EteSync](https://www.etesync.com/)** - Sincronização segura de dados pessoais

#### 🌐 **Mídia e Entretenimento**

- [ ] **[qBittorrent](https://www.qbittorrent.org/)** - Cliente torrent web
- [ ] **RSS Reader** - Agregador de feeds RSS
- [ ] **[Jellyfin](https://jellyfin.org/)** - Media server open-source
- [ ] **[Plex](https://www.plex.tv/)** - Media server (alternativa)
- [ ] **[ErsatzTV](https://ersatztv.org/)** - Cria canais de TV personalizados
- [ ] **[Tunarr](https://tunarr.com/)** - Programação de TV a partir da sua biblioteca
- [ ] **[Riven](https://rivenmedia.github.io/wiki/)** - Gerenciador de mídia automatizado
- [ ] **[WatchState](https://github.com/arabcoders/watchstate)** - Sincronização de progresso entre players
- [ ] **[Fladder](https://github.com/DonutWare/Fladder)** - Cliente Jellyfin multiplataforma
- [ ] **[PinePods](https://www.pinepods.online/)** - Servidor de podcasts self-hosted
- [ ] **[Neko](https://neko.m1k1o.net/)** - Browser compartilhado virtual

#### � **Email e Comunicação**

- [ ] **[Addy.io](https://addy.io/)** - Alias de email para privacidade

#### 🏃 **Saúde e Fitness**

- [ ] **[wger](https://wger.de/pt-br/software/features)** - Gerenciador de treinos e dieta
- [ ] **[Strava Statistics](https://statistics-for-strava.robiningelbrecht.be/dashboard)** - Análise de dados de corrida
- [ ] **[Fitbit Grafana](https://github.com/arpanghosh8453/fitbit-grafana)** - Dashboard fitness no Grafana
- [ ] **Habit Tracking** - Sistema de acompanhamento de hábitos

#### 🔑 **Autenticação e Privacidade**

- [ ] **[Vaultwarden](https://github.com/dani-garcia/vaultwarden)** - Movido para Prioridade Alta
- [ ] **[2FAuth](https://docs.2fauth.app/)** - Movido para Prioridade Alta

#### 🖥️ **Ferramentas de Sistema**

- [ ] **[Termix](https://github.com/LukeGus/Termix/tree/main)** - Terminal multiplataforma
- [ ] **In-Memory Cache** - Redis/Memcached para performance

#### 📍 **Localização**

- [ ] **[Dawarich](https://dawarich.app/)** - Rastreamento de localização pessoal

### 🛠️ **Melhorias na Stack Atual**

#### ⚡ **Otimizações Imediatas**

- [ ] **SSL/TLS automático** - Let's Encrypt com Traefik
- [ ] **Backup automatizado** - Scripts para volumes críticos
- [ ] **Alertas inteligentes** - Configuração do AlertManager
- [ ] **Dashboard unificado** - Melhorias no Homarr

#### 🔄 **Integrações**

- [ ] **SSO (Single Sign-On)** - Autenticação centralizada
- [ ] **Reverse Proxy** - Nginx/Traefik para todos os serviços
- [ ] **Monitoring avançado** - Integração Netdata + Grafana
- [ ] **CI/CD Pipeline** - Gitea + automação de deploy

### 📊 **Critérios de Priorização**

| Critério              | Peso   | Descrição                   |
| --------------------- | ------ | --------------------------- |
| **Complementaridade** | 🔥🔥🔥 | Melhora serviços existentes |
| **Segurança**         | 🔥🔥🔥 | Aumenta proteção da stack   |
| **Automação**         | 🔥🔥   | Reduz trabalho manual       |
| **Produtividade**     | 🔥🔥   | Ferramentas do dia a dia    |
| **Recursos**          | 🔥     | Impacto na performance      |
| **Complexidade**      | 🔥     | Facilidade de implementação |

---

## 🎬 **Destaque: Ecossistema de Mídia Completo**

### 🎯 **Stack de Entretenimento Recomendada**

Para uma experiência completa de mídia self-hosted, a combinação recomendada é:

#### **Base (Prioridade Média)**

1. **🎥 Jellyfin/Plex** - Servidor de mídia principal
2. **📺 ErsatzTV ou Tunarr** - Criação de canais de TV personalizados
3. **🤖 Riven** - Automação completa de aquisição de mídia

#### **Complementos (Prioridade Baixa)**

1. **📱 Fladder** - Cliente Jellyfin multiplataforma
2. **🔄 WatchState** - Sincronização de progresso entre dispositivos
3. **🎧 PinePods** - Servidor de podcasts
4. **🌐 Neko** - Browser compartilhado para streaming online
5. **⬇️ qBittorrent** - Aquisição de conteúdo

### 💡 **Por que essa Stack?**

- **🎪 Experiência de TV tradicional** com canais programados
- **🤖 Automação completa** de download e organização
- **📱 Acesso multiplataforma** com sincronização
- **🎧 Podcasts integrados** na mesma infraestrutura
- **👥 Compartilhamento social** com browser virtual

---

## 📝 Notas

- **Fuso horário**: Configurado para `America/Sao_Paulo`
- **Recursos**: Ollama limitado a 16GB RAM
- **Modelos**: Configurados para modelos até 7B localmente
- **APIs**: Suporte para OpenRouter, OpenAI, Anthropic, Google

**Desenvolvido e mantido para uso pessoal/educacional** 🏠✨
