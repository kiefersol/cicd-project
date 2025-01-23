resource "local_file" "hosts_manual_cfg" {
  content = templatefile(var.template_file,
    {
      jumpbox_ip   = var.jumpbox_ip
      infra_ip     = var.infra_ips
      infra_count  = var.infra_count
      master_ip    = var.master_ips
      master_count = var.master_count
      worker_ip    = var.worker_ips
      worker_count = var.worker_count
    }
  )
  filename = var.inventory_file
}