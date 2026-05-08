# 
# Variáveis Terraform - APENAS DEFINIÇÕES
# Arquivo: variables.tf
# 

variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI Profile"
  type        = string
  default     = "default"
}

variable "environment" {
  description = "Ambiente (DEV, STAGING, PROD)"
  type        = string
  default     = "DEV"
  
  validation {
    condition     = contains(["DEV", "STAGING", "PROD"], var.environment)
    error_message = "Environment deve ser: DEV, STAGING ou PROD."
  }
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "ragflow"
}

variable "instance_type" {
  description = "Tipo de instância EC2"
  type        = string
  default     = "t2.xlarge"
}

variable "ami_id" {
  description = "AMI ID (Ubuntu 22.04 LTS)"
  type        = string
  default     = "ami-091138d0f0d41ff90"
}

variable "volume_size" {
  description = "Tamanho do volume EBS em GB"
  type        = number
  default     = 50
  
  validation {
    condition     = var.volume_size >= 30
    error_message = "Volume deve ter no mínimo 30GB."
  }
}

variable "volume_type" {
  description = "Tipo de volume EBS"
  type        = string
  default     = "gp3"
}

variable "enable_monitoring" {
  description = "Habilitar CloudWatch monitoring"
  type        = bool
  default     = true
}

variable "allowed_ssh_cidrs" {
  description = "CIDRs permitidos para SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "Tags adicionais"
  type        = map(string)
  default = {
    Owner       = "Gilvan"
    CostCenter  = "Development"
  }
}