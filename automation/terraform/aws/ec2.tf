module "sol_bastion_node" {
  source                 = "./modules/ec2/bastion_ec2"
  ec2_name               = join("-", ["${var.vpc_name}", "jumpbox"])
  ec2_image_code         = var.bastion_image_code
  ec2_product_code       = var.bastion_product_code
  loginkey               = aws_key_pair.sol_loginkey.key_name
  nic_id                 = module.sol_nic_public.nic_info.id
  nic_order              = 0 #네트워크 인터페이스 연결의 정수 인덱스
  root_block_device_size = var.bastion_root_block_device_size
  init_script            = var.infra_init
}

module "sol_infra_node" {
  source                 = "./modules/ec2/infra_ec2"
  count                  = var.infra_count
  ec2_name               = join("-", ["${var.vpc_name}", "infra", count.index])
  ec2_image_code         = var.infra_image_code
  ec2_product_code       = var.infra_product_code
  loginkey               = aws_key_pair.sol_loginkey.key_name
  nic_id                 = module.sol_nic_private[count.index].nic_info.id
  nic_order              = 0 #네트워크 인터페이스 연결의 정수 인덱스
  root_block_device_size = var.infra_root_block_device_size
  ebs_block_device_size  = var.infra_ebs_root_block_device_size
  init_script            = var.infra_init
}

module "sol_master_node" {
  source                 = "./modules/ec2/k8s_ec2"
  count                  = var.master_count
  ec2_name               = join("-", ["${var.vpc_name}", "master", count.index])
  ec2_image_code         = var.master_image_code
  ec2_product_code       = var.master_product_code
  loginkey               = aws_key_pair.sol_loginkey.key_name
  nic_id                 = module.sol_nic_master[count.index].nic_info.id
  nic_order              = 0 #네트워크 인터페이스 연결의 정수 인덱스
  root_block_device_size = var.master_root_block_device_size
  ebs_block_device_size  = var.master_ebs_root_block_device_size
  vpc_name               = var.vpc_name
  iam_instance_profile   = module.sol_iam_master_profile[0].iam_profile_info.name
  init_script            = var.k8s_init
  infra_node_ip          = module.sol_infra_node[0].ec2_info.private_ip
}

module "sol_worker_node" {
  source                 = "./modules/ec2/k8s_ec2"
  count                  = var.worker_count
  ec2_name               = join("-", ["${var.vpc_name}", "worker", count.index])
  ec2_image_code         = var.worker_image_code
  ec2_product_code       = var.worker_product_code
  loginkey               = aws_key_pair.sol_loginkey.key_name
  nic_id                 = module.sol_nic_worker[count.index].nic_info.id
  nic_order              = 0
  root_block_device_size = var.worker_root_block_device_size
  ebs_block_device_size  = var.worker_ebs_root_block_device_size
  vpc_name               = var.vpc_name
  iam_instance_profile   = module.sol_iam_worker_profile[0].iam_profile_info.name
  init_script            = var.k8s_init
  infra_node_ip          = module.sol_infra_node[0].ec2_info.private_ip
}

