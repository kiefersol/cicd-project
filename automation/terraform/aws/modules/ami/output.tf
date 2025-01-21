output "ami_info" {
  value       = aws_ami_from_instance.sol_k8s_ami
  description = "ami info"
}