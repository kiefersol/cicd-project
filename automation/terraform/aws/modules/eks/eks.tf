resource "aws_eks_cluster" "sol_eks_cluster" {
  name     = var.eks_name
  role_arn = var.eks_role_arn
  version  = var.eks_version
  vpc_config {
    security_group_ids = var.eks_security_group_ids
    subnet_ids         = var.eks_subnet_ids
  }
  depends_on = [
    var.eks_policy_AmazonEKSClusterPolicy,
    var.eks_policy_AmazonEKSServicePolicy,
    var.eks_policy_AmazonEBSCSIDriverPolicy
  ]
}