# 
# Security Group para RAGFlow
# Arquivo: security_group.tf
# 

resource "aws_security_group" "ragflow_sg" {
  name        = "${var.project_name}-sg"
  description = "Security Group para RAGFlow - Portas: 22 (SSH), 80 (HTTP), 443 (HTTPS), 9380 (API), 11434 (Ollama)"
  
  tags = {
    Name = "${var.project_name}-sg"
  }
}

# SSH (porta 22)
resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ssh_cidrs
  security_group_id = aws_security_group.ragflow_sg.id
  description       = "SSH - Acesso remoto"
}

# HTTP (porta 80)
resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ragflow_sg.id
  description       = "HTTP - RAGFlow Web"
}

# HTTPS (porta 443)
resource "aws_security_group_rule" "https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ragflow_sg.id
  description       = "HTTPS - RAGFlow Web (SSL)"
}

# RAGFlow API (porta 9380)
resource "aws_security_group_rule" "ragflow_api" {
  type              = "ingress"
  from_port         = 9380
  to_port           = 9380
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ragflow_sg.id
  description       = "RAGFlow API"
}

# Ollama LLM (porta 11434)
resource "aws_security_group_rule" "ollama" {
  type              = "ingress"
  from_port         = 11434
  to_port           = 11434
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ragflow_sg.id
  description       = "Ollama - LLM Local"
}

# Egress (Saída - Permitir tudo)
resource "aws_security_group_rule" "egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ragflow_sg.id
  description       = "Permitir todo trafego de saida"
}