# Guia de Deployment - RAGFlow em AWS EC2

> Passo-a-passo detalhado para fazer deploy do RAGFlow em produção na AWS.

**Versão:** 1.0.0  
**Última atualização:** Maio 2026

---

## 📋 Índice

1. [Pré-deployment](#pré-deployment)
2. [Configuração do Terraform](#configuração-do-terraform)
3. [Deployment Passo-a-Passo](#deployment-passo-a-passo)
4. [Validação Pós-Deployment](#validação-pós-deployment)
5. [Acessar a Instância](#acessar-a-instância)
6. [Monitoramento](#monitoramento)

---

## 🔧 Pré-deployment

### 1. Verificar Credenciais AWS
```bash
# Confirmar que AWS CLI está configurado
aws sts get-caller-identity

# Output esperado:
# {
#     "UserId": "AIDAI...",
#     "Account": "123456789012",
#     "Arn": "arn:aws:iam::123456789012:user/seu-usuario"
# }