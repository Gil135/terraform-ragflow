#!/bin/bash

# 
# USER DATA - EC2 Ubuntu para RAGFlow + AWS
# Com inicialização automática via systemd 
# Otimizado para: velocidade, segurança, espaço em disco
# Tempo estimado: 5-10 minutos
# 

set -e  # Parar em qualquer erro

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Arquivo de log (em /home/ubuntu, sem necessidade de sudo)
LOG_DIR="/home/ubuntu/ragflow-logs"
LOG_FILE="$LOG_DIR/setup.log"

# Criar diretório de logs com permissões corretas
mkdir -p "$LOG_DIR"
chmod 755 "$LOG_DIR"

# Função para logging
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
    exit 1
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1" | tee -a "$LOG_FILE"
}

# 
# 1. ATUALIZAR SISTEMA
# 
log "Atualizando sistema..."
sudo apt-get update -qq || warn "apt-get update falhou"
sudo apt-get upgrade -y -qq || warn "apt-get upgrade falhou"

# 
# 2. INSTALAR DOCKER (versão estável)
# 
log "Instalando Docker..."
sudo apt-get install -y -qq ca-certificates curl gnupg lsb-release

# Adicionar repositório oficial Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --batch --yes --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -qq
sudo apt-get install -y -qq docker-ce docker-ce-cli containerd.io

log "Docker instalado: $(docker --version)"

# 
# 3. ATIVAR DOCKER NO BOOT
# 
log "Ativando Docker no boot..."
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
sudo systemctl start docker.service

# Aguardar Docker estar pronto
sleep 5

# 
# 4. INSTALAR DOCKER COMPOSE v2 (ATUALIZADO)
# 
log "Instalando Docker Compose v2..."
DOCKER_COMPOSE_VERSION="v2.27.0"
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

log "Docker Compose instalado: $(docker-compose --version)"

# 
# 5. INSTALAR AWS CLI v2
# 
log "Instalando AWS CLI v2..."
sudo apt-get install -y -qq unzip

cd /tmp
curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install
rm -rf /tmp/aws /tmp/awscliv2.zip

log "AWS CLI instalado: $(aws --version)"

# 
# 6. INSTALAR PYTHON 3 + UV
# 
log "Instalando Python 3 e uv..."
sudo apt-get install -y -qq python3-full python3-pip python3-venv

# Instalar uv via snap (com --classic)
sudo snap install astral-uv --classic 2>/dev/null || warn "uv já instalado"

log "Python: $(python3 --version)"
log "uv instalado"

# 
# 7. CONFIGURAR PERMISSÕES DOCKER (sem sudo)
# 
log "Configurando permissões Docker..."
sudo usermod -aG docker ubuntu
newgrp docker

# 
# 8. CLONAR E PREPARAR RAGFLOW
# 
log "Clonando RAGFlow..."
cd /home/ubuntu

# Remover diretório anterior se existir
[ -d ragflow ] && rm -rf ragflow

git clone --depth 1 https://github.com/infiniflow/ragflow.git
cd ragflow


log "RAGFlow clonado com sucesso"



LOG_DIR="/home/ubuntu/ragflow-logs-start"
LOG_FILE="$LOG_DIR/startup.log"

# Criar diretório de logs com permissões corretas
sudo mkdir -p "$LOG_DIR"
sudo chown ubuntu:ubuntu "$LOG_DIR"
chmod 755 "$LOG_DIR"




log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "=========================================="
log "Iniciando RAGFlow"
log "=========================================="

# Aguardar Docker estar pronto (máx 60 segundos)
log "Aguardando Docker estar pronto..."
for i in {1..60}; do
    if docker ps &>/dev/null; then
        log "✓ Docker está pronto"
        break
    fi
    log "  Tentativa $i/60..."
    sleep 1
done

# Verificar se Docker respondeu
if ! docker ps &>/dev/null; then
    log "✗ ERRO: Docker não respondeu após 60 segundos"
    exit 1
fi

# Navegar para diretório do RAGFlow
RAGFLOW_DIR="/home/ubuntu/ragflow"
if [ ! -d "$RAGFLOW_DIR" ]; then
    log "✗ ERRO: Diretório $RAGFLOW_DIR não encontrado"
    exit 1
fi

cd "$RAGFLOW_DIR"
log "Diretório: $(pwd)"

# Verificar se docker-compose.yml existe no caminho correto
if [ ! -f "docker/docker-compose.yml" ]; then
    log "✗ ERRO: docker/docker-compose.yml não encontrado"
    log "Arquivos disponíveis:"
    ls -la >> "$LOG_FILE"
    exit 1
fi

# Iniciar containers usando "docker compose" (v2 - sem hífen)
log "Executando: docker compose -f docker/docker-compose.yml up -d"
docker compose -f docker/docker-compose.yml up -d >> "$LOG_FILE" 2>&1 || {
    log "✗ ERRO ao iniciar containers"
    log "Tentando com docker-compose (v1)..."
    docker-compose -f docker/docker-compose.yml up -d >> "$LOG_FILE" 2>&1 || {
        log "✗ ERRO: Ambos os comandos falharam"
        exit 1
    }
}

# Aguardar containers estarem prontos
log "Aguardando containers iniciarem..."
sleep 10

# Verificar status
log "Status dos containers:"
docker ps >> "$LOG_FILE"

log "✓ RAGFlow iniciado com sucesso"
log "=========================================="
log "Logs disponíveis em: $LOG_FILE"

exit 0

# 
# ============================================================
# 9. CRIAR SCRIPT DE INICIALIZAÇÃO AUTOMÁTICA
# ============================================================
# 

log "Criando script de inicialização automática..."

cat > /home/ubuntu/start-ragflow.sh << 'SCRIPT_EOF'
#!/bin/bash

# 
# Script para iniciar RAGFlow automaticamente
# Localização: /home/ubuntu/start-ragflow.sh
# Executado por: systemd (ragflow.service)
# 

set -e

LOG_DIR="/home/ubuntu/ragflow-logs-start"
LOG_FILE="$LOG_DIR/startup.log"

# Criar diretório de logs com permissões corretas
sudo mkdir -p "$LOG_DIR"
sudo chown ubuntu:ubuntu "$LOG_DIR"
chmod 755 "$LOG_DIR"




log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "=========================================="
log "Iniciando RAGFlow"
log "=========================================="

# Aguardar Docker estar pronto (máx 60 segundos)
log "Aguardando Docker estar pronto..."
for i in {1..60}; do
    if docker ps &>/dev/null; then
        log "✓ Docker está pronto"
        break
    fi
    log "  Tentativa $i/60..."
    sleep 1
done

# Verificar se Docker respondeu
if ! docker ps &>/dev/null; then
    log "✗ ERRO: Docker não respondeu após 60 segundos"
    exit 1
fi

# Navegar para diretório do RAGFlow
RAGFLOW_DIR="/home/ubuntu/ragflow"
if [ ! -d "$RAGFLOW_DIR" ]; then
    log "✗ ERRO: Diretório $RAGFLOW_DIR não encontrado"
    exit 1
fi

cd "$RAGFLOW_DIR"
log "Diretório: $(pwd)"

# Verificar se docker-compose.yml existe no caminho correto
if [ ! -f "docker/docker-compose.yml" ]; then
    log "✗ ERRO: docker/docker-compose.yml não encontrado"
    log "Arquivos disponíveis:"
    ls -la >> "$LOG_FILE"
    exit 1
fi

# Iniciar containers usando "docker compose" (v2 - sem hífen)
log "Executando: docker compose -f docker/docker-compose.yml up -d"
docker compose -f docker/docker-compose.yml up -d >> "$LOG_FILE" 2>&1 || {
    log "✗ ERRO ao iniciar containers"
    log "Tentando com docker-compose (v1)..."
    docker-compose -f docker/docker-compose.yml up -d >> "$LOG_FILE" 2>&1 || {
        log "✗ ERRO: Ambos os comandos falharam"
        exit 1
    }
}

# Aguardar containers estarem prontos
log "Aguardando containers iniciarem..."
sleep 10

# Verificar status
log "Status dos containers:"
docker ps >> "$LOG_FILE"

log "✓ RAGFlow iniciado com sucesso"
log "=========================================="
log "Logs disponíveis em: $LOG_FILE"

exit 0
SCRIPT_EOF

# Dar permissão de execução
chmod +x /home/ubuntu/start-ragflow.sh
chown ubuntu:ubuntu /home/ubuntu/start-ragflow.sh



log "Script de inicialização criado: /home/ubuntu/start-ragflow.sh"

# 
# ============================================================
# 10. CRIAR SERVIÇO SYSTEMD
# ============================================================
# 

log "Criando serviço systemd para inicialização automática..."



sudo tee /etc/systemd/system/ragflow.service > /dev/null << 'SERVICE_EOF'
[Unit]
Description=RAGFlow Docker Service
After=docker.service
Requires=docker.service
Documentation=https://github.com/infiniflow/ragflow

[Service]
Type=oneshot
User=ubuntu
Group=ubuntu
WorkingDirectory=/home/ubuntu/ragflow
ExecStart=/home/ubuntu/start-ragflow.sh
RemainAfterExit=yes
StandardOutput=journal
StandardError=journal

# Reiniciar se falhar
Restart=on-failure
RestartSec=10

# Timeout
TimeoutStartSec=300

[Install]
WantedBy=multi-user.target
SERVICE_EOF

log "Serviço systemd criado: /etc/systemd/system/ragflow.service"

# 
# ============================================================
# 11. ATIVAR SERVIÇO PARA BOOT AUTOMÁTICO
# ============================================================
# 

log "Ativando serviço para inicialização automática..."
sudo systemctl daemon-reload
sudo systemctl enable ragflow.service

log "Serviço ragflow ativado para boot automático"

# 
# ============================================================
# 12. RESUMO FINAL
# ============================================================
# 

log ""
log "╔════════════════════════════════════════════════════════╗"
log "║          ✅ SETUP CONCLUÍDO COM SUCESSO!              ║"
log "╚════════════════════════════════════════════════════════╝"
log ""
log "📋 RESUMO:"
log "  • Docker: $(docker --version)"
log "  • Docker Compose: $(docker-compose --version)"
log "  • AWS CLI: $(aws --version)"
log "  • Python: $(python3 --version)"
log "  • RAGFlow: Clonado em /home/ubuntu/ragflow"
log ""
log "🚀 INICIALIZAÇÃO AUTOMÁTICA:"
log "  • Serviço: ragflow.service"
log "  • Status: Ativado para boot automático"
log "  • RAGFlow iniciará automaticamente ao reiniciar a instância"
log ""
log "📝 COMANDOS ÚTEIS:"
log "  • Ver status: sudo systemctl status ragflow.service"
log "  • Ver logs: sudo journalctl -u ragflow.service -f"
log "  • Ver logs de startup: tail -f /home/ubuntu/ragflow-logs-start/startup.log"
log "  • Parar: sudo systemctl stop ragflow.service"
log "  • Reiniciar: sudo systemctl restart ragflow.service"
log ""
log "📍 LOCALIZAÇÃO DOS ARQUIVOS:"
log "  • Script de startup: /home/ubuntu/start-ragflow.sh"
log "  • Serviço systemd: /etc/systemd/system/ragflow.service"
log "  • Logs de setup: /home/ubuntu/ragflow-logs/setup.log"
log "  • Logs de startup: /home/ubuntu/ragflow-logs/startup.log"
log "  • RAGFlow: /home/ubuntu/ragflow"
log ""
log "🌐 ACESSO:"
log "  • RAGFlow estará disponível em: http://seu-ip-ec2"
log "  • Após a instância iniciar completamente (~3-5 min)"
log ""
log "⏱️  Tempo total de setup: ~5-10 minutos"
log ""

exit 0