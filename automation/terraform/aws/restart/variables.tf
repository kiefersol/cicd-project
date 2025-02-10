variable "region" {
  description = "region"
  type        = string
}

variable "ec2_ids" {
  description = "ec2 instance ids"
  type        = list(string)
}

variable "ec2_state" {
  description = "ec2 state"
  type        = string
}
