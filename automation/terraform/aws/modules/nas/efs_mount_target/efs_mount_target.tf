resource "aws_efs_mount_target" "sol_efs_mount_target" {
  file_system_id  = var.efs_id
  subnet_id       = var.subnet_id
  security_groups = var.acg_id
}