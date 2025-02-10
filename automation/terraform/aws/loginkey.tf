resource "aws_key_pair" "sol_loginkey" {
  key_name   = join("-", ["${var.vpc_name}", "${var.system_type}", "key"])
  public_key = file("~/.ssh/id_rsa.pub")
}