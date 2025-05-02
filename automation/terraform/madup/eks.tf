# eks
resource "aws_eks_cluster" "eks" {
  name     = var.vpc_name
  role_arn = aws_iam_role.eks_iam_role.arn
  version  = var.eks_version
  vpc_config {
    subnet_ids         = aws_subnet.subnet[*].id
  }
  depends_on = [
    aws_iam_role_policy_attachment.k8s-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.k8s-cluster-AmazonEKSServicePolicy,
    aws_iam_role_policy_attachment.k8s-cluster-AmazonEBSCSIDriverPolicy,
  ]
}

data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = var.vpc_name
}

# Kubectl 연결
locals {
  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: "${aws_eks_cluster.eks.endpoint}"
    certificate-authority-data: "${aws_eks_cluster.eks.certificate_authority.0.data}"
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${var.vpc_name}"
      env:
        - name: AWS_ACCESS_KEY_ID
          value: "${var.access_key}"
        - name: AWS_SECRET_ACCESS_KEY
          value: "${var.secret_key}"
        - name: AWS_PROFILE
          value: "${var.vpc_name}"
KUBECONFIG
}

output "kubeconfig" {
  value = local.kubeconfig
}

# nodegroup
resource "aws_launch_template" "nodegroup_launch_template" {
  name = join("-", ["${var.vpc_name}", "nodegroup", "launch_template"])
  key_name      = aws_key_pair.loginkey.key_name
  instance_type = var.nodegroup_instance_type
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = var.nodegroup_volume_size
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }
  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.nodegroup_sg.id]
  }
}

resource "aws_eks_node_group" "nodegroup" {
  cluster_name    = aws_eks_cluster.eks.name
  version         = var.nodegroup_version
  node_group_name = join("-", ["${var.vpc_name}","nodegroup"])
  node_role_arn   = aws_iam_role.ng_iam_role.arn
  subnet_ids      = aws_subnet.subnet[*].id

  launch_template {
    name    = aws_launch_template.nodegroup_launch_template.name
    version = "$Latest"
  }

  scaling_config {
    desired_size = tonumber(var.k8s_node_worker_size["desired"])
    min_size     = tonumber(var.k8s_node_worker_size["min"])
    max_size     = tonumber(var.k8s_node_worker_size["max"])
  }

  # 새로운 대체 객체가 먼저 생성되고 대체 객체가 생성된 후 이전 객체가 파괴되도록 함
  lifecycle {
    create_before_destroy = true  # 무중단 업그레이드
  }

  tags = {
    "Name" = join("-", ["${var.vpc_name}","nodegroup"]),
    join("/", ["k8s.io", "cluster-autoscaler", "${var.vpc_name}"]) = "shared",
    join("/", ["k8s.io", "cluster-autoscaler", "enabled"]) = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.k8s-worker-AmazonAutoScailingPolicy,
    aws_iam_role_policy_attachment.k8s-worker-AmazonAutoScailingPolicy,
    aws_iam_role_policy_attachment.k8s-worker-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.k8s-worker-AmazonEC2ContainerRegistryReadOnly
  ]
}