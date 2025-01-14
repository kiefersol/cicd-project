# public subnet - bastion ec2, lb 사용 서브넷
module "sol_subnet_public" {
  source                  = "./modules/subnet"
  count                   = 1
  vpc_id                  = data.aws_vpc.vpc_info.id
  cidr_block              = var.subnet_public_cidr[count.index]
  availability_zone       = var.zone[count.index]
  map_public_ip_on_launch = "true" # public subnet
  subnet_name             = join("-", ["${var.vpc_name}", lower("${var.zone[count.index]}"), "public", "subnet"])
  vpc_name                = var.vpc_name
  system_type             = var.system_type
}

# private subnet - infra, kubernetes (master, worker) ec2 사용 서브넷
module "sol_subnet_private" {
  source                  = "./modules/subnet"
  count                   = length(var.zone)
  vpc_id                  = data.aws_vpc.vpc_info.id
  cidr_block              = var.subnet_private_cidr[count.index]
  availability_zone       = var.zone[count.index]
  map_public_ip_on_launch = false # private subnet
  subnet_name             = join("-", ["${var.vpc_name}", lower("${var.zone[count.index]}"), "private", "subnet"])
  vpc_name                = var.vpc_name
  system_type             = var.system_type
}









