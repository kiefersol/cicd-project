output "iam_policy_attachment_info" {
  value       = aws_iam_role_policy_attachment.sol_iam_role_policy_attachment
  description = "iam policy attachment info"
}