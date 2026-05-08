
---


# Arquitetura Técnica - RAGFlow em AWS EC2

> Documentação detalhada da arquitetura, componentes e fluxo de dados.

**Versão:** 1.0.0  
**Última atualização:** Maio 2026

---

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Componentes](#componentes)
3. [Fluxo de Dados](#fluxo-de-dados)
4. [Configuração de Rede](#configuração-de-rede)
5. [Segurança](#segurança)
6. [Escalabilidade](#escalabilidade)

---

## 🎯 Visão Geral

A arquitetura do RAGFlow em AWS é baseada em:

- **Infraestrutura:** AWS EC2 (Elastic Compute Cloud)
- **Containerização:** Docker + Docker Compose
- **Orquestração:** systemd (gerenciamento de serviços)
- **Rede:** VPC (Virtual Private Cloud) com Security Groups
- **Persistência:** EBS (Elastic Block Store) para armazenamento

**Stack Tecnológico:**
- Ubuntu 22.04 LTS (SO)
- Docker 24.x + Docker Compose v2
- Python 3.10+
- RAGFlow (aplicação principal)
- Redis (cache/fila)
- Ollama (modelos de IA)

---

## 🏗️ Componentes

### 1. AWS EC2 Instance

**Tipo:** t2.xlarge (recomendado para produção)

| Especificação | Valor |
|---|---|
| vCPU | 4 |
| Memória RAM | 16 GB |
| Armazenamento | 50 GB EBS (gp3) |
| Rede | 1 Gbps |
| SO | Ubuntu 22.04 LTS |

**Responsabilidades:**
- Executar containers Docker
- Gerenciar serviços via systemd
- Armazenar dados em EBS
- Conectar à internet via Internet Gateway

---

### 2. Docker Containers

#### RAGFlow (porta 9380)

**Imagem:** `ragflow:latest`

**Responsabilidades:**
- Aplicação principal de IA Generativa
- Interface web (porta 9380)
- Processamento de requisições
- Integração com Ollama

**Variáveis de Ambiente:**
```bash
OLLAMA_API_BASE=http://ollama:11434
REDIS_URL=redis://redis:6379
LOG_LEVEL=INFO