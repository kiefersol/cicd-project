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

variable "zone" {
  description = "availability_zone"
    default     = "ap-northeast-2a" # 서울
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

