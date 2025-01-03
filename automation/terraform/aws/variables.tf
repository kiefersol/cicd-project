# VPC
variable "vpc_cidr" {
  description = "vpc cidr"
  type        = string
}

variable "vpc_name" {
  description = "vpc name"
  type        = string
}

variable "region" {
  description = "vpc region"
  default     = "ap-northeast-2" # 서울
  type        = string
}

# subnet
variable "zone" {
  description = "availability_zone"
  type        = list(string)
}

variable "subnet_public_cidr" {
  description = "public subnet cidr"
  type        = list(string)
}

variable "subnet_private_cidr" {
  description = "private subnet cidr"
  type        = list(string)
}

# EC2

variable "master_count" {
  description = "master count"
  type        = number
}

variable "worker_count" {
  description = "worker count"
  type        = number
}

variable "infra_count" {
  description = "infra count"
  type        = number
}


