# EKS
resource "aws_iam_role" "eks_iam_role" {
  name = join("-", ["${var.vpc_name}", "eks_role"])
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "eks.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}
# EKS 클러스터 자체가 AWS API를 호출할 수 있게 해주는 권한
resource "aws_iam_role_policy_attachment" "k8s-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_iam_role.name
}
# EKS 관리형 서비스와 통합하기 위한 권한
resource "aws_iam_role_policy_attachment" "k8s-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_iam_role.name
}
# EBS CSI 드라이버가 EBS 볼륨을 동적으로 생성/삭제할 수 있도록 허용 - EBS 볼륨 기반 PVC를 쓸 때 필수
resource "aws_iam_role_policy_attachment" "k8s-cluster-AmazonEBSCSIDriverPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.eks_iam_role.name
}

# Node Group
resource "aws_iam_role" "ng_iam_role" {
  name = join("-", ["${var.vpc_name}", "nodegroup_role"])
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

# 오토스케일링 그룹을 모니터링하고, 필요에 따라 확장/축소하거나 EC2 인스턴스를 종료할 수 있는 권한
resource "aws_iam_policy" "ng_iam_policy_autoscaler" {
  name = join("-", ["${var.vpc_name}", "nodegroup_policy_autoscaler"])
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "ec2:DescribeLaunchTemplateVersions"
        ]
        Resource = "*"
      }
    ]
  })
}

# 오토스케일링 그룹을 모니터링하고, 필요에 따라 확장/축소하거나 EC2 인스턴스를 종료할 수 있는 권한
resource "aws_iam_role_policy_attachment" "k8s-worker-AmazonAutoScailingPolicy" {
  policy_arn = aws_iam_policy.ng_iam_policy_autoscaler.arn
  role       = aws_iam_role.ng_iam_role.name
}

# EKS 워커 노드가 클러스터 API 서버와 통신할 수 있도록 허용 - 클러스터 등록, 상태 보고, 로깅 등 기본 역할을 수행하는 데 필요
resource "aws_iam_role_policy_attachment" "k8s-worker-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.ng_iam_role.name
}

# VPC CNI 플러그인 (aws-node DaemonSet) 이 ENI(Elastic Network Interface)를 생성/삭제할 수 있도록 허용
resource "aws_iam_role_policy_attachment" "k8s-worker-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.ng_iam_role.name
}

# 워커 노드가 Amazon ECR에서 컨테이너 이미지를 pull 할 수 있게 해줌 - 필수 x
resource "aws_iam_role_policy_attachment" "k8s-worker-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.ng_iam_role.name
}