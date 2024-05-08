## entry point of terraform project.
#module "frontend" {
#  depends_on = [module.backend]
#
#  source = "./modules/app"
#  instance_type = var.instance_type
#  component = "frontend"
#  env = var.env
#  zone_id = var.zone_id
#  vault_token = var.vault_token
#}
#module "backend" {
#  depends_on = [module.database]
#
#  source = "./modules/app"
#  instance_type = var.instance_type
#  component = "backend"
#  env = var.env
#  zone_id = var.zone_id
#  vault_token = var.vault_token
#}
#module "database" {
#  source = "./modules/app"
#  instance_type = var.instance_type
#  component = "database"
#  env = var.env
#  zone_id = var.zone_id
#  vault_token = var.vault_token
#}

module "vpc" {
  source = "./modules/vpc"
  env = var.env
  vpc_ip_block = var.vpc_ip_block
  subnet_ip_block = var.subnet_ip_block
  default_vpc_id = var.default_vpc_id
  default_vpc_ip_block = var.default_vpc_ip_block
  default_rtb_id = var.default_rtb_id
}