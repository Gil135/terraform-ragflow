# 
# EC2 Instance - RAGFlow
# Arquivo: main.tf
# 

resource "aws_instance" "ragflow" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  iam_instance_profile   = aws_iam_instance_profile.ragflow_profile.name
  vpc_security_group_ids = [aws_security_group.ragflow_sg.id]
  
  # User Data Script
  user_data_base64 = base64encode(file("${path.module}/../scripts/user_data.sh"))

  # Configuração de armazenamento
  root_block_device {
    volume_type           = var.volume_type
    volume_size           = var.volume_size
    delete_on_termination = true
    encrypted             = false
    iops                  = 3000
    throughput            = 125

    tags = {
      Name = "${var.project_name}-root-volume"
    }
  }

  # Monitoramento
  monitoring = var.enable_monitoring

  # Tags
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-instance"
    }
  )

  # Dependências explícitas
  depends_on = [
    aws_security_group.ragflow_sg,
    aws_iam_instance_profile.ragflow_profile
  ]
}