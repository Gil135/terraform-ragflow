terraform {
  required_providers {
    aws={
        source = "hashicorp/aws"
        version = ">= 4.16"
            }
  }
  required_version = ">= 1.2.0"
}

resource "aws_instance" "ragflow_instance" {

  ami = "ami-091138d0f0d41ff90"
  instance_type                        = "t2.xlarge"
  region                               = "us-east-1"
  secondary_private_ips                = []
  security_groups                      = ["SG RAGFlow"]
  iam_instance_profile                 = "role-acesso-ssm"

  
tags = {
  ambiente ="DEV"
  Name = "Ragflow-Instance"
  
}


tenancy                   = "default"
user_data                 = file("${path.module}/user_data.sh") # Instala Docker + RAGFlow v0.24.0
volume_tags               = null
vpc_security_group_ids    = ["sg-02ae2cd21f022a811"]


capacity_reservation_specification {
  capacity_reservation_preference = "open"
}


 root_block_device {
    delete_on_termination = true
    encrypted             = false
    iops                  = 3000
    tags                  = {}
    tags_all              = {}
    throughput            = 125
    volume_size           = 50
    volume_type           = "gp3"
  }
}

