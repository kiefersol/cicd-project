{
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "ec2:*",
          "elasticloadbalancing:*",
          "route53:*",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:BatchGetImage",
          "kms:DescribeKey",
          "kms:Decrypt",
          "kms:GenerateDataKeyWithoutPlaintext",
          "kms:CreateGrant"
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      }
    ]
}