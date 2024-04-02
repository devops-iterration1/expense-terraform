module "frontend" {
  source = "./modules/app"
  instance_type = var.instance_type
  component = "frontend"
  ssh_user = var.ssh_user
  ssh_pass = var.ssh_pass
  env = var.env
  zone_id = var.zone_id
  depends_on = [module.backend]
}
module "backend" {
  source = "./modules/app"
  instance_type = var.instance_type
  component = "backend"
  ssh_user = var.ssh_user
  ssh_pass = var.ssh_pass
  env = var.env
  zone_id = var.zone_id
  depends_on = [module.database]
}
module "database" {
  source = "./modules/app"
  instance_type = var.instance_type
  component = "database"
  ssh_user = var.ssh_user
  ssh_pass = var.ssh_pass
  env = var.env
  zone_id = var.zone_id
}