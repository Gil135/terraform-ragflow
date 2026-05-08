# RAGFlow - Deployment Automático em AWS EC2

> Projeto de Infrastructure as Code (IaC) para deploy startup do RAGFlow em AWS com Terraform e User Data Script.

**Autor:** Gilvan  
**Data:** Maio 2026  
**Status:** ✅ Produção  
**Versão:** 1.0.0

---

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Arquitetura](#arquitetura)
3. [Pré-requisitos](#pré-requisitos)
4. [Estrutura do Projeto](#estrutura-do-projeto)
5. [Instalação Rápida](#instalação-rápida)
6. [Próximos Passos](#próximos-passos)

---

## 🎯 Visão Geral

Este projeto automatiza o deployment do **RAGFlow** (plataforma de IA Generativa) em uma instância **EC2** da AWS com:

- ✅ **Docker** + Docker Compose v2
- ✅ **RAGFlow** (clone automático do repositório)
- ✅ **AWS CLI v2** (integração com serviços AWS)
- ✅ **Python 3** + uv (gerenciador de dependências)
- ✅ **Inicialização Automática** via systemd
- ✅ **Infrastructure as Code** com Terraform
- ✅ **Security Group** com portas configuradas (80, 443, 9380, 11434)

---

## 🏗️ Arquitetura
```mermaid
graph TD
    A["<b>AWS EC2 Instance</b><br/>(t2.xlarge, 50GB EBS, Ubuntu 22.04)"]
    
    B["<b>Docker Containers</b><br/>RAGFlow porta 9380<br/>Redis porta 6379<br/>Ollama porta 11434"]
    
    C["<b>Serviço systemd</b><br/>ragflow.service<br/>Auto-restart on boot"]
    
    D["Security Group<br/>(Firewall)"]
    E["Internet Gateway"]
    F["Usuários"]
    
    A --> B
    A --> C
    A --> D
    D --> E
    E --> F
    
    style A fill:#FF9900,stroke:#333,color:#000,stroke-width:2px
    style B fill:#146EB4,stroke:#333,color:#fff,stroke-width:2px
    style C fill:#27AE60,stroke:#333,color:#fff,stroke-width:2px
    style D fill:#E74C3C,stroke:#333,color:#fff,stroke-width:2px
    style E fill:#34495E,stroke:#333,color:#fff,stroke-width:2px
    style F fill:#8E44AD,stroke:#333,color:#fff,stroke-width:2px


## 📦 Pré-requisitos

### Obrigatório

- ✅ **Conta AWS** com permissões de EC2, VPC, Security Groups
- ✅ **Terraform** >= 1.2.0 instalado localmente
- ✅ **AWS CLI** v2 configurado com credenciais
- ✅ **Git** para clonar o repositório
- ✅ **Chave SSH** criada na AWS (para acessar a instância)

### Verificar Instalação
```bash
# Terraform
terraform --version
# Output: Terraform v1.x.x

# AWS CLI
aws --version
# Output: aws-cli/2.x.x

# Git
git --version
# Output: git version 2.x.xConfigurar AWS CLIbash1234567891011# Configurar credenciais
aws configure

# Inserir:
# AWS Access Key ID: [sua-chave]
# AWS Secret Access Key: [sua-chave-secreta]
# Default region: us-east-1
# Default output format: json

# Verificar configuração
aws sts get-caller-identity📁 Estrutura do Projetotextragflow-terraform/
├── README.md                    # Este arquivo
├── DEPLOYMENT.md                # Guia passo-a-passo
├── .gitignore                   # Ignorar arquivos sensíveis
│
├── scripts/
│   └── user_data.sh             # Script de inicialização EC2
│
├── terraform/
│   ├── main.tf                  # Configuração principal
│   ├── security_group.tf        # Regras de firewall
│   ├── variables.tf             # Variáveis
│   ├── terraform.tfvars         # Valores das variáveis
│   └── outputs.tf               # Outputs (IP, DNS, etc)
│
└── docs/
    ├── TROUBLESHOOTING.md       # Solução de problemas
    ├── ARCHITECTURE.md          # Detalhes da arquitetura
    └── COMMANDS.md              # Comandos úteis🚀 Instalação Rápida1️⃣ Clonar Repositóriobash12git clone https://github.com/seu-usuario/ragflow-terraform.git
cd ragflow-terraform2️⃣ Configurar Terraformbash12345678910cd terraform

# Inicializar Terraform
terraform init

# Validar configuração
terraform validate

# Formatar código
terraform fmt -recursive3️⃣ Revisar Planobash1234567# Ver o que será criado
terraform plan -out=tfplan

# Output mostrará:
# - 1 aws_instance (EC2)
# - 1 aws_security_group
# - 5 aws_security_group_rule (portas)4️⃣ Aplicar Configuraçãobash1234# Criar recursos na AWS
terraform apply tfplan

# Aguarde 3-5 minutos para o deployment completar5️⃣ Acessar a Instânciabash1234567891011# Obter IP público
terraform output instance_public_ip

# Conectar via SSH
ssh -i /caminho/para/sua-chave.pem ubuntu@<IP_PUBLICO>

# Verificar status do RAGFlow
sudo systemctl status ragflow.service

# Ver logs
sudo journalctl -u ragflow.service -f