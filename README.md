# RAGFlow - Deployment Automático em AWS EC2

> Projeto de Infrastructure as Code (IaC) para deploy automático do RAGFlow em AWS com Terraform e User Data Script.

**Autor:** Gilvan  
**Data:** Maio 2026  
**Status:** ✅ Produção  
**Versão:** 1.0.0

---

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Pré-requisitos](#pré-requisitos)
3. [Estrutura do Projeto](#estrutura-do-projeto)
4. [Instalação Rápida](#instalação-rápida)
5. [Scripts IaC](#scripts-iac)
6. [Terraform](#terraform)
7. [Troubleshooting](#troubleshooting)
8. [Próximos Passos](#próximos-passos)

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

### Arquitetura

┌┐
│         AWS EC2 Instance                │
│  (t2.xlarge, 50GB EBS, Ubuntu 22.04)    │
├┤
│                                         │
│  ┌──────────────────────────────────┐   │
│  │   Docker Containers              │   │
│  ├──────────────────────────────────┤   │
│  │ • RAGFlow (porta 9380)           │   │
│  │ • Redis (porta 6379)             │   │
│  │ • Ollama (porta 11434)           │   │
│  └──────────────────────────────────┘   │
│                                         │
│  ┌──────────────────────────────────┐   │
│  │   Serviço systemd                │   │
│  │   (ragflow.service)              │   │
│  │   Auto-restart on boot           │   │
│  └──────────────────────────────────┘   │
│                                         │
└┘
↓
Security Group
(Firewall)
↓
Internet Gateway
↓
Usuários

---

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
# Output: git version 2.x.x
Configurar AWS CLI
´´
# Configurar credenciais
aws configure

# Inserir:
# AWS Access Key ID: [sua-chave]
# AWS Secret Access Key: [sua-chave-secreta]
# Default region: us-east-1
# Default output format: json

# Verificar configuração
aws sts get-caller-identity´´

 Estrutura do Projeto  
 ragflow-terraform/
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
│   └── outputs.tf               # Outputs (opcional)
│
└── docs/
    ├── TROUBLESHOOTING.md       # Solução de problemas
    ├── ARCHITECTURE.md          # Detalhes da arquitetura
    └── COMMANDS.md              # Comandos úteis   


