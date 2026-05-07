# # __generated__ by Terraform
# # Please review these resources and move them into your main configuration files.

# # __generated__ by Terraform
# resource "aws_instance" "ragflow_instance" {
#   ami                                  = "ami-091138d0f0d41ff90"
#   associate_public_ip_address          = false
#   availability_zone                    = "us-east-1d"
#   disable_api_stop                     = false
#   disable_api_termination              = false
#   ebs_optimized                        = false
#   force_destroy                        = false
#   get_password_data                    = false
#   hibernation                          = false
#   instance_initiated_shutdown_behavior = "stop"
#   instance_type                        = "t2.xlarge"
#   ipv6_address_count                   = 0
#   #ipv6_addresses                       = []
#   key_name                             = "ragflow"
#   monitoring                           = false
#   placement_partition_number           = 0
#   #private_ip                           = "172.31.43.215"
#   region                               = "us-east-1"
#   secondary_private_ips                = []
#   security_groups                      = ["SG RAGFlow"]
#   source_dest_check                    = true
#   subnet_id                            = "subnet-021e099b16686ebcd"
#   tags = {
#     Name = "ragflow_instance"
#   }
#   tags_all = {
#     Name = "ragflow_instance"
#   }
#   tenancy                     = "default"
#   user_data                   = "#!/bin/bash\n# Atualiza os índices de pacotes do Ubuntu\napt-get update -y\n\n# Instala o Git sem exigir interação do usuário (-y)\napt-get install git -y"
#   user_data_replace_on_change = null
#   volume_tags                 = null
#   vpc_security_group_ids      = ["sg-02ae2cd21f022a811"]
#   capacity_reservation_specification {
#     capacity_reservation_preference = "open"
#   }
#   cpu_options {
#     core_count       = 4
#     threads_per_core = 1
#   }
#   credit_specification {
#     cpu_credits = "standard"
#   }
#   enclave_options {
#     enabled = false
#   }
#   maintenance_options {
#     auto_recovery = "default"
#   }
#   metadata_options {
#     http_endpoint               = "enabled"
#     http_protocol_ipv6          = "disabled"
#     http_put_response_hop_limit = 2
#     http_tokens                 = "required"
#     instance_metadata_tags      = "disabled"
#   }
#   primary_network_interface {
#     network_interface_id = "eni-0d397ebe196264f0d"
#   }
#   private_dns_name_options {
#     enable_resource_name_dns_a_record    = true
#     enable_resource_name_dns_aaaa_record = false
#     hostname_type                        = "ip-name"
#   }
#   root_block_device {
#     delete_on_termination = true
#     encrypted             = false
#     iops                  = 3000
#     tags                  = {}
#     tags_all              = {}
#     throughput            = 125
#     volume_size           = 50
#     volume_type           = "gp3"
#   }
# }
