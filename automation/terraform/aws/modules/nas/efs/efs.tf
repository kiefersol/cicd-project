resource "aws_efs_file_system" "sol_efs" {
  creation_token = var.efs_token_name
  # 암호화 설정
  encrypted = var.efs_encrypted
  # 성능 설정 - generalPurpose(기본값), maxIO
  performance_mode = var.efs_performance_mode
  # 처리량 설정 bursting (기본값), provisioned, elastic
  throughput_mode = var.efs_throughput_mode

  # 비정기적으로 액세스되는 데이터를 자동으로 EFS IA(Infrequent Access) 스토리지 클래스로 전환
  #   lifecycle_policy {
  #     transition_to_archive- "AFTER_30_DAYS" # 파일을 보관 저장소 클래스로 전환하는 데 걸리는 시간
  #   }

  tags = tomap({
    "Name"                                                     = var.efs_name,
    "kubernetes.io/cluster/${var.vpc_name}-${var.system_type}" = "owned"
  })
}
