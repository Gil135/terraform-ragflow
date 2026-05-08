# 
# IAM Role para SSM (Systems Manager)
# Arquivo: iam_role.tf
# 

resource "aws_iam_role" "ragflow_ssm_role" {
  name               = "${var.project_name}-ssm-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-ssm-role"
  }
}

# SSM (Systems Manager)
resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = aws_iam_role.ragflow_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# CloudWatch Logs
resource "aws_iam_role_policy_attachment" "cloudwatch_logs" {
  role       = aws_iam_role.ragflow_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# S3 (Opcional - para backups)
resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.ragflow_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# RDS (Opcional - para acesso ao banco)
resource "aws_iam_role_policy" "rds_access" {
  name = "${var.project_name}-rds-access"
  role = aws_iam_role.ragflow_ssm_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "rds:DescribeDBInstances",
          "rds:DescribeDBClusters",
          "rds-db:connect"
        ]
        Resource = "*"
      }
    ]
  })
}

# Instance Profile
resource "aws_iam_instance_profile" "ragflow_profile" {
  name = "${var.project_name}-instance-profile"
  role = aws_iam_role.ragflow_ssm_role.name
}