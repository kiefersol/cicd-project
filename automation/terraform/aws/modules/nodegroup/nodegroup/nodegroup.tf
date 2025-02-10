resource "aws_eks_node_group" "sol_nodegroup" {
  cluster_name    = var.eks_name
  node_group_name = var.nodegroup_name
  node_role_arn   = var.nodegroup_role_arn
  subnet_ids      = var.nodegroup_subnet_ids

  launch_template {
    name    = var.nodegroup_launch_template_name
    version = "$Latest"
  }

  scaling_config {
    desired_size = var.nodegroup_scaling_desired
    min_size     = var.nodegroup_scaling_min
    max_size     = var.nodegroup_scaling_max
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    var.eks_policy_AmazonEKSWorkerNodePolicy,
    var.eks_policy_AmazonEKS_CNI_Policy,
    var.eks_policy_AmazonEC2ContainerRegistryReadOnly,
    var.eks_policy_AmazonAutoScailingPolicy
  ]

  tags = {
    "Name"                                                                            = var.nodegroup_name
    join("/", ["k8s.io", "cluster-autoscaler", "${var.vpc_name}-${var.system_type}"]) = "owned"
    join("/", ["k8s.io", "cluster-autoscaler", "enabled"])                            = true
  }
}