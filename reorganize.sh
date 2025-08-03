#!/bin/bash

# 🏗️ Script de Reorganização da Infraestrutura Self-Hosted
# Migra da estrutura atual para a nova organização por categorias

set -e  # Para se houver erro

echo "🏗️ Iniciando reorganização da infraestrutura..."
echo ""

# Verificar se estamos no diretório correto
if [[ ! -f "scripts/cli.sh" ]]; then
    echo "❌ Erro: Execute este script no diretório raiz do projeto self-hosted"
    exit 1
fi

# 💾 BACKUP COMPLETO ANTES DA REORGANIZAÇÃO
BACKUP_DIR="backup_$(date +%Y%m%d_%H%M%S)"
echo "💾 Criando backup completo em: $BACKUP_DIR"

# Criar diretório de backup
mkdir -p "$BACKUP_DIR"

# Fazer backup de todos os arquivos importantes
echo "  📋 Fazendo backup de arquivos de configuração..."
rsync -av --exclude="$BACKUP_DIR" \
    --exclude=".git" \
    --exclude="*.log" \
    --exclude="node_modules" \
    . "$BACKUP_DIR/"

echo "✅ Backup criado com sucesso!"
echo "  📁 Localização: ./$BACKUP_DIR"
echo "  🔄 Para reverter: rm -rf homarr ai-llms observability security networking databases automation media productivity && cp -r $BACKUP_DIR/* ."
echo ""

# Criar script de rollback automático
cat > "rollback_$BACKUP_DIR.sh" << 'EOF'
#!/bin/bash
echo "🔄 Iniciando rollback da reorganização..."
echo "⚠️  ATENÇÃO: Isso irá reverter TODAS as mudanças!"
read -p "Tem certeza? (s/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]; then
    echo "🗑️ Removendo nova estrutura..."
    rm -rf dashboards ai-llms observability security networking databases automation media productivity
    echo "📋 Restaurando estrutura original..."
    cp -r BACKUP_DIR_PLACEHOLDER/* .
    echo "✅ Rollback concluído!"
else
    echo "❌ Rollback cancelado"
fi
EOF

# Substituir placeholder com o nome real do backup
sed -i "s/BACKUP_DIR_PLACEHOLDER/$BACKUP_DIR/g" "rollback_$BACKUP_DIR.sh"
chmod +x "rollback_$BACKUP_DIR.sh"

echo "📝 Script de rollback criado: rollback_$BACKUP_DIR.sh"
echo ""

# Confirmar antes de prosseguir
read -p "🤔 Deseja prosseguir com a reorganização? (s/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "❌ Reorganização cancelada. Backup mantido em $BACKUP_DIR"
    exit 0
fi

echo "📁 Criando nova estrutura de diretórios..."

# Criar estrutura de diretórios
mkdir -p dashboards
mkdir -p ai-llms  
mkdir -p observability/{metrics,logs,tracing,system-monitoring}
mkdir -p security/{network-protection,auth,firewall,vpn-tunnels}
mkdir -p networking/{proxy,utilities}
mkdir -p databases/{postgres,cache}
mkdir -p automation/{workflows,home-automation,scraping,backup}
mkdir -p media/{servers,streaming,management,clients,podcasts}
mkdir -p productivity/{collaboration,documentation,development,finance,personal}

echo "✅ Estrutura de diretórios criada!"
echo ""

echo "🔄 Movendo serviços existentes..."

# Mover homarr
if [[ -d "homarr" ]]; then
    echo "  📊 Movendo homarr/ → dashboards/"
    mv homarr/ dashboards/
fi

# Mover LLMs (renomear pasta)
if [[ -d "llms" ]]; then
    echo "  🤖 Movendo llms/ → ai-llms/"
    mv llms/* ai-llms/ 2>/dev/null || true
    rmdir llms/ 2>/dev/null || true
fi

# Mover monitoring para observability/metrics
if [[ -d "monitoring" ]]; then
    echo "  📊 Movendo monitoring/ → observability/metrics/"
    mv monitoring/* observability/metrics/ 2>/dev/null || true
    rmdir monitoring/ 2>/dev/null || true
fi

# Mover postgres (corrigir nome também)
if [[ -d "postgress" ]]; then
    echo "  💾 Movendo postgress/ → databases/postgres/"
    mv postgress/ databases/postgres/
fi

# Mover serviços de network
if [[ -d "network/pihole" ]]; then
    echo "  🔐 Movendo network/pihole/ → security/network-protection/"
    mv network/pihole/ security/network-protection/
fi

if [[ -d "network/tailscale" ]]; then
    echo "  🔐 Movendo network/tailscale/ → security/vpn-tunnels/"
    mv network/tailscale/ security/vpn-tunnels/
fi

# Remover diretório network se vazio
if [[ -d "network" ]] && [[ -z "$(ls -A network)" ]]; then
    echo "  🗑️ Removendo diretório network/ vazio"
    rmdir network/
fi

echo ""
echo "✅ Migração de serviços concluída!"
echo ""

echo "🧪 Testando script de gerenciamento..."

# Testar se o cli.sh ainda funciona
if ./scripts/cli.sh list > /dev/null 2>&1; then
    echo "✅ Script cli.sh funcionando corretamente!"
else
    echo "⚠️ Aviso: Verifique o script cli.sh manualmente"
fi

echo ""
echo "🎉 Reorganização concluída com sucesso!"
echo ""
echo "� Informações do backup:"
echo "  📁 Backup salvo em: $BACKUP_DIR"
echo "  🔄 Para reverter: ./${BACKUP_DIR/backup_/rollback_}.sh"
echo ""
echo "�📋 Próximos passos:"
echo "  1. Verificar se todos os serviços estão funcionando: ./scripts/cli.sh status"
echo "  2. Testar inicialização: ./scripts/cli.sh up"
echo "  3. Se tudo estiver OK, você pode remover o backup: rm -rf $BACKUP_DIR"
echo "  4. Atualizar documentação se necessário"
echo ""
echo "📁 Nova estrutura:"
echo "  📊 dashboards/          - Homarr e dashboards futuros"
echo "  🤖 ai-llms/            - Todos os LLMs e IAs"
echo "  📊 observability/       - Monitoramento, logs, tracing"
echo "  🔐 security/            - Segurança, firewall, VPN"
echo "  🌐 networking/          - Proxy e utilitários de rede"
echo "  💾 databases/           - PostgreSQL e caches futuros"
echo "  🔄 automation/          - Automação e workflows futuros"
echo "  🎬 media/               - Mídia e entretenimento futuros"
echo "  📝 productivity/        - Produtividade e colaboração futuras"
echo "  🛠️ scripts/            - Scripts de gerenciamento (sem mudanças)"
echo ""
