resource "aws_efs_access_point" "sol_efs_access_point" {
  file_system_id = var.efs_id
  root_directory {
    path = var.efs_path
    creation_info {
      owner_gid   = var.efs_gid
      owner_uid   = var.efs_uid
      permissions = var.efs_permissions
    }
  }
  tags = tomap({
    "Name"                                                     = var.efs_access_point_name,
    "kubernetes.io/cluster/${var.vpc_name}-${var.system_type}" = "owned"
  })
}