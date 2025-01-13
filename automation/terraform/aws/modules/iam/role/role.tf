resource "aws_iam_role" "sol_iam_role" {
  name               = var.role_name
  assume_role_policy = jsonencode(jsondecode(templatefile(var.role_policy_file, {})))
  tags = {
    name = var.role_name
  }
}