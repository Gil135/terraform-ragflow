# 
# Outputs Consolidados - ARQUIVO ÚNICO
# Arquivo: outputs.tf
# 

# ============================================================
# EC2 Instance
# ============================================================

output "instance_id" {
  description = "ID da instância EC2"
  value       = aws_instance.ragflow.id
}

output "instance_public_ip" {
  description = "IP público da instância"
  value       = aws_instance.ragflow.public_ip
}

output "instance_private_ip" {
  description = "IP privado da instância"
  value       = aws_instance.ragflow.private_ip
}

output "instance_arn" {
  description = "ARN da instância"
  value       = aws_instance.ragflow.arn
}

# ============================================================
# Security Group
# ============================================================

output "security_group_id" {
  description = "ID do Security Group"
  value       = aws_security_group.ragflow_sg.id
}

output "security_group_name" {
  description = "Nome do Security Group"
  value       = aws_security_group.ragflow_sg.name
}

output "security_group_arn" {
  description = "ARN do Security Group"
  value       = aws_security_group.ragflow_sg.arn
}

# ============================================================
# IAM Role & Instance Profile
# ============================================================

output "iam_role_arn" {
  description = "ARN da IAM Role"
  value       = aws_iam_role.ragflow_ssm_role.arn
}

output "iam_role_name" {
  description = "Nome da IAM Role"
  value       = aws_iam_role.ragflow_ssm_role.name
}

output "instance_profile_name" {
  description = "Nome do Instance Profile"
  value       = aws_iam_instance_profile.ragflow_profile.name
}

output "instance_profile_arn" {
  description = "ARN do Instance Profile"
  value       = aws_iam_instance_profile.ragflow_profile.arn
}

# ============================================================
# SSM (Systems Manager) - Acesso Remoto
# ============================================================

output "ssm_session_command" {
  description = "Comando AWS CLI para acessar via Session Manager (sem SSH)"
  value       = "aws ssm start-session --target ${aws_instance.ragflow.id} --profile ${var.aws_profile}"
}

output "ssm_session_command_simple" {
  description = "Comando AWS CLI simplificado para Session Manager"
  value       = "aws ssm start-session --target ${aws_instance.ragflow.id}"
}

output "ssm_console_url" {
  description = "URL do console AWS para iniciar Session Manager"
  value       = "https://console.aws.amazon.com/systems-manager/session-manager/start-session?target=${aws_instance.ragflow.id}&region=${var.aws_region}"
}

output "ssm_instance_info" {
  description = "Informações para acessar via SSM"
  value = {
    instance_id = aws_instance.ragflow.id
    region      = var.aws_region
    profile     = var.aws_profile
    command     = "aws ssm start-session --target ${aws_instance.ragflow.id} --profile ${var.aws_profile}"
  }
}

# ============================================================
# URLs de Acesso
# ============================================================

output "ragflow_http_url" {
  description = "URL HTTP para acessar RAGFlow"
  value       = "http://${aws_instance.ragflow.public_ip}"
}

output "ragflow_https_url" {
  description = "URL HTTPS para acessar RAGFlow (após configurar SSL)"
  value       = "https://${aws_instance.ragflow.public_ip}"
}

output "ssh_command" {
  description = "Comando SSH para acessar a instância (requer chave SSH)"
  value       = "ssh -i sua-chave.pem ubuntu@${aws_instance.ragflow.public_ip}"
}

# ============================================================
# Resumo Completo
# ============================================================

output "deployment_summary" {
  description = "Resumo completo do deployment"
  value = {
    # Instância
    instance_id       = aws_instance.ragflow.id
    public_ip         = aws_instance.ragflow.public_ip
    private_ip        = aws_instance.ragflow.private_ip
    instance_type     = var.instance_type
    
    # Segurança
    security_group    = aws_security_group.ragflow_sg.name
    iam_role          = aws_iam_role.ragflow_ssm_role.name
    
    # Acesso
    ragflow_url       = "http://${aws_instance.ragflow.public_ip}"
    ssh_command       = "ssh -i sua-chave.pem ubuntu@${aws_instance.ragflow.public_ip}"
    ssm_command       = "aws ssm start-session --target ${aws_instance.ragflow.id} --profile ${var.aws_profile}"
    
    # Configuração
    environment       = var.environment
    region            = var.aws_region
    profile           = var.aws_profile
  }
}

# ============================================================
# Instruções de Acesso
# ============================================================

output "access_instructions" {
  description = "Instruções de acesso à instância"
  value = <<-EOT
    
    ╔════════════════════════════════════════════════════════╗
    ║         INSTRUÇÕES DE ACESSO - RAGFLOW                ║
    ╚════════════════════════════════════════════════════════╝
    
    1️⃣  ACESSAR VIA SESSION MANAGER (Recomendado - sem SSH):
    ────────────────────────────────────────────────────────
    aws ssm start-session --target ${aws_instance.ragflow.id} --profile ${var.aws_profile}
    
    Ou via console AWS:
    ${replace("https://console.aws.amazon.com/systems-manager/session-manager/start-session?target=${aws_instance.ragflow.id}&region=${var.aws_region}", "https://", "")}
    
    2️⃣  ACESSAR VIA SSH (requer chave SSH):
    ────────────────────────────────────────────────────────
    ssh -i sua-chave.pem ubuntu@${aws_instance.ragflow.public_ip}
    
    3️⃣  ACESSAR RAGFLOW:
    ────────────────────────────────────────────────────────
    HTTP:  http://${aws_instance.ragflow.public_ip}
    HTTP-API:  http://${aws_instance.ragflow.public_ip}:9380
    HTTPS: https://${aws_instance.ragflow.public_ip}
    
    4️⃣  VERIFICAR STATUS:
    ────────────────────────────────────────────────────────
    # Via SSM
    aws ssm start-session --target ${aws_instance.ragflow.id} --profile ${var.aws_profile}
    
    # Dentro da sessão:
    docker ps
    sudo systemctl status ragflow.service
    tail -f /home/ubuntu/ragflow-logs/startup.log
    
    ╔════════════════════════════════════════════════════════╗
    ║  Instância: ${aws_instance.ragflow.id}
    ║  IP Público: ${aws_instance.ragflow.public_ip}
    ║  Ambiente: ${var.environment}
    ║  Região: ${var.aws_region}
    ╚════════════════════════════════════════════════════════╝
  EOT
}