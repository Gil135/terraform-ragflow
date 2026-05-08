# # 
# # Security Group para RAGFlow
# # Arquivo: security_group.tf
# # 

# resource "aws_security_group" "ragflow_sg" {
#   name        = "SG-RAGFlow"
#   description = "Security Group para RAGFlow com portas HTTP, HTTPS, API e Ollama"
#   vpc_id      = null  # Usar VPC padrão

#   tags = {
#     Name        = "SG-RAGFlow"
#     Environment = "DEV"
#     Application = "RAGFlow"
#   }
# }

# # 
# # INGRESS RULES (Entrada)
# # 

# # HTTP (porta 80)
# resource "aws_security_group_rule" "ragflow_http" {
#   type              = "ingress"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.ragflow_sg.id
#   description       = "HTTP - RAGFlow Web"
# }

# # HTTPS (porta 443)
# resource "aws_security_group_rule" "ragflow_https" {
#   type              = "ingress"
#   from_port         = 443
#   to_port           = 443
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.ragflow_sg.id
#   description       = "HTTPS - RAGFlow Web (SSL)"
# }

# # RAGFlow API (porta 9380)
# resource "aws_security_group_rule" "ragflow_api" {
#   type              = "ingress"
#   from_port         = 9380
#   to_port           = 9380
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.ragflow_sg.id
#   description       = "RAGFlow API"
# }

# # Ollama LLM (porta 11434)
# resource "aws_security_group_rule" "ragflow_ollama" {
#   type              = "ingress"
#   from_port         = 11434
#   to_port           = 11434
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.ragflow_sg.id
#   description       = "Ollama - LLM Local"
# }

# # SSH (porta 22)
# resource "aws_security_group_rule" "ragflow_ssh" {
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.ragflow_sg.id
#   description       = "SSH - Acesso remoto"
# }

# # 
# # EGRESS RULES (Saída - Permitir tudo)
# # 

# resource "aws_security_group_rule" "ragflow_egress" {
#   type              = "egress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.ragflow_sg.id
#   description       = "Permitir todo tráfego de saída"
# }

# # 
# # OUTPUT - ID do Security Group
# # 

# output "security_group_id" {
#   description = "ID do Security Group RAGFlow"
#   value       = aws_security_group.ragflow_sg.id
# }

# output "security_group_name" {
#   description = "Nome do Security Group RAGFlow"
#   value       = aws_security_group.ragflow_sg.name
# }