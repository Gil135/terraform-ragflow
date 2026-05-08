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

A infraestrutura é composta por:

**1. AWS EC2 Instance** (t2.xlarge, 50GB EBS, Ubuntu 22.04)
- **Docker Containers:**
  - RAGFlow (porta 9380)
  - Redis (porta 6379)
  - Ollama (porta 11434)
- **Serviço systemd** (ragflow.service)
  - Auto-restart on boot
  - Gerenciamento automático

**2. Security Group** (Firewall)
- Controla acesso às portas
- Regras de entrada/saída configuradas

**3. Internet Gateway**
- Conecta a instância à internet pública
- Permite acesso dos usuários

**4. Usuários**
- Acessam RAGFlow via HTTP/HTTPS (porta 80)

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

# Configurar credenciais
aws configure

# Inserir:
# AWS Access Key ID: [sua-chave]
# AWS Secret Access Key: [sua-chave-secreta]
# Default region: us-east-1
# Default output format: json

# Verificar configuração
aws sts get-caller-identity  
```
## 📁 Estrutura do Projeto
 ```
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
│   └── outputs.tf               # Outputs (IP, DNS, etc)
│
└── docs/
    ├── TROUBLESHOOTING.md       # Solução de problemas
    ├── ARCHITECTURE.md          # Detalhes da arquitetura
    └── COMMANDS.md              # Comandos úteis  
```
## 🚀 Instalação Rápida  

1️⃣ Clonar Repositório  

git clone https://github.com/Gil135/ragflow-terraform.git
cd ragflow-terraform  

2️⃣ Configurar Terraform  

cd terraform

# Inicializar Terraform
```
terraform init

```
# Validar configuração
```
terraform validate

# Formatar código
terraform fmt -recursive  
```
3️⃣ Revisar Plano  
```
# Ver o que será criado
terraform plan -out=tfplan

# Output mostrará:
# - 1 aws_instance (EC2)
# - 1 aws_security_group
# - 5 aws_security_group_rule (portas)  
 
```
4️⃣ Aplicar Configuração  
```
# Criar recursos na AWS
terraform apply tfplan

# Aguarde 3-5 minutos para o deployment completar  
# Criar recursos na AWS

```
5️⃣ Acessar a Instância   
```
# Obter IP público
terraform output instance_public_ip

# Conectar via SSH
ssh -i /caminho/para/sua-chave.pem ubuntu@<IP_PUBLICO>

# Verificar status do RAGFlow
sudo systemctl status ragflow.service

# Ver logs
sudo journalctl -u ragflow.service -f

```
## ✅ Próximos Passos  

 Ler DEPLOYMENT.md para detalhes completos  
 Consultar TROUBLESHOOTING.md em caso de erros  
 Revisar ARCHITECTURE.md para entender a infraestrutura  
 Executar comandos em COMMANDS.md  

📞 SuportePara dúvidas ou problemas, consulte a documentação ou abra uma issue no repositório.   


Licença: MIT  
Mantido por: Gilvan