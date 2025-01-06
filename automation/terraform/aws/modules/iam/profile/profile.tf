resource "aws_iam_instance_profile" "sol_iam_profile" {
  name = var.profile_name
  role = var.role_name
}