module "sol_eks_cluster" {
  source                              = "./modules/eks"
  count                               = var.k8s_eks_install ? 1 : 0
  eks_name                            = join("-", ["${var.vpc_name}", "${var.system_type}"])
  eks_role_arn                        = module.sol_eks_role[0].iam_role_info.arn
  eks_version                         = var.k8s_cluster_version
  eks_security_group_ids              = [module.sol_eks_sg[0].sg_info.id]                                 # 수정 필요
  eks_subnet_ids                      = [for subnet in module.sol_subnet_private : subnet.subnet_info.id] # 서브넷 2개 이상 필요
  eks_policy_AmazonEKSClusterPolicy   = module.k8s-cluster-AmazonEKSClusterPolicy[0].iam_policy_attachment_info.policy_arn
  eks_policy_AmazonEKSServicePolicy   = module.k8s-cluster-AmazonEKSServicePolicy[0].iam_policy_attachment_info.policy_arn
  eks_policy_AmazonEBSCSIDriverPolicy = module.k8s-cluster-AmazonEBSCSIDriverPolicy[0].iam_policy_attachment_info.policy_arn
}

# Kubectl 연결
locals {
  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${var.k8s_eks_install ? module.sol_eks_cluster[0].eks_info.endpoint : ""}
    certificate-authority-data: ${var.k8s_eks_install ? module.sol_eks_cluster[0].eks_info.certificate_authority.0.data : ""}
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
        - "${var.vpc_name}-${var.system_type}"
      env:
        - name: AWS_ACCESS_KEY_ID
          value: "${var.access_key}"
        - name: AWS_SECRET_ACCESS_KEY
          value: "${var.secret_key}"
        - name: AWS_PROFILE
          value: "${var.system_type}"
KUBECONFIG
}

output "kubeconfig" {
  value = local.kubeconfig
}

