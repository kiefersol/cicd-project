resource "local_file" "ansible_manual_vars" {
  content = templatefile(var.template_file,
    {
      cloud_provider       = var.cloud_provider
      nas_path             = var.nas_path
      nas_server           = var.nas_server
      nas_name             = var.nas_name
      nas_dns              = var.nas_dns
      nas_mount_path       = var.nas_mount_path
      nas_mountoptions     = var.nas_mountoptions
      region               = var.region
      access_key           = var.access_key
      secret_key           = var.secret_key
      system_type          = var.system_type
      jumpbox_ip           = var.jumpbox_ip
      infra_lb_domain_name = var.infra_lb_domain_name
      k8s_lb_domain_name   = var.k8s_lb_domain_name
      infra_ip             = var.infra_ip
      vpc_id               = var.vpc_id
      vpc_name             = var.vpc_name
      k8s_version          = var.k8s_version
      asg_min_size         = var.asg_min_size
      asg_max_size         = var.asg_max_size
      k8s_pod_cidr         = var.k8s_pod_cidr
      k8s_service_cidr     = var.k8s_service_cidr
      master_count         = var.master_count
      master_ip            = var.master_ips
      ansible_path         = var.ansible_path
      k8s_service_type     = var.k8s_service_type
    }
  )
  filename = var.vars_file
}