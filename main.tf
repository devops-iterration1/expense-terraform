## entry point of terraform project.
module "frontend" {
  depends_on = [module.backend]

  source = "./modules/app"
  instance_type = var.instance_type
  component = "frontend"
  env = var.env
  zone_id = var.zone_id
  vault_token = var.vault_token
  vpc_id = module.vpc.vps_id
  subnets = module.vpc.fe_subnets
  lb_type = "public"
  lb_needed = true
  lb_subnet = module.vpc.public_subnets
}
module "backend" {
  depends_on = [module.database]

  source = "./modules/app"
  instance_type = var.instance_type
  component = "backend"
  env = var.env
  zone_id = var.zone_id
  vault_token = var.vault_token
  vpc_id = module.vpc.vps_id
  subnets = module.vpc.be_subnets
  lb_type = "public"
  lb_needed = true
  lb_subnet = module.vpc.be_subnets
}
module "database" {
  source = "./modules/app"
  instance_type = var.instance_type
  component = "database"
  env = var.env
  zone_id = var.zone_id
  vault_token = var.vault_token
  vpc_id = module.vpc.vps_id
  subnets = module.vpc.db_subnets
}

module "vpc" {
  source = "./modules/vpc"
  env = var.env
  vpc_ip_block = var.vpc_ip_block
  default_vpc_id = var.default_vpc_id
  default_vpc_ip_block = var.default_vpc_ip_block
  default_rtb_id = var.default_rtb_id
  be_subnets = var.db_subnets
  db_subnets = var.be_subnets
  fe_subnets = var.fe_subnets
  availability_zones = var.availability_zones
  public_subnets = var.public_subnets
}