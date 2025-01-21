variable "efs_id" {
  description = "efs id"
  type        = string
}

variable "subnet_id" {
  description = "subnet id"
  type        = string
}

variable "sg_id" {
  description = "acg_id"
  type        = list(string)
}