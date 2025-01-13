resource "aws_iam_policy" "sol_iam_policy" {
  name   = var.policy_name
  policy = jsonencode(jsondecode(templatefile(var.policy_file, {})))
}