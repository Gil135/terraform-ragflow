
---
# Troubleshooting - RAGFlow em AWS EC2

> Solução de problemas comuns durante deployment e operação.

**Versão:** 1.0.0

---

## 📋 Índice

1. [Problemas de Terraform](#problemas-de-terraform)
2. [Problemas de Conectividade](#problemas-de-conectividade)
3. [Problemas de Docker](#problemas-de-docker)
4. [Problemas de Serviço](#problemas-de-serviço)
5. [Problemas de Performance](#problemas-de-performance)

---

## 🔴 Problemas de Terraform

### Erro: "Error: error configuring Terraform AWS Provider"

**Causa:** Credenciais AWS não configuradas ou inválidas.

**Solução:**
```bash
# Verificar credenciais
aws sts get-caller-identity

# Se falhar, reconfigurar
aws configure

# Inserir:
# AWS Access Key ID: [sua-chave]
# AWS Secret Access Key: [sua-chave-secreta]
# Default region: us-east-1
# Default output format: json