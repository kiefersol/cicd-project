# VPC
vpc_name = "cicd"
vpc_cidr = "10.0.0.0/16"
region   = "ap-northeast-2"

# Subnet
zone                = ["ap-northeast-2a"]
subnet_public_cidr  = ["10.0.2.0/24"]
subnet_private_cidr = ["10.0.3.0/24"]

# EC2
infra_count  = 1
master_count = 1
worker_count = 1