module "instance_state" {
  source             = "./modules"
  count              = length(var.ec2_ids)
  ec2_instance_id    = var.ec2_ids[count.index]
  ec2_instance_state = var.ec2_state
}
#stopped, running