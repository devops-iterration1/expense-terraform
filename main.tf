# entry point of terraform project.
module "frontend" {
  source = "./modules/app"
  instance_type = var.instance_type
  component = "frontend"
  env = var.env
  zone_id = var.zone_id
  vault_token = var.vault_token
  depends_on = [module.backend]
}
module "backend" {
  source = "./modules/app"
  instance_type = var.instance_type
  component = "backend"
  env = var.env
  zone_id = var.zone_id
  vault_token = var.vault_token
  depends_on = [module.database]
}
module "database" {
  source = "./modules/app"
  instance_type = var.instance_type
  component = "database"
  env = var.env
  zone_id = var.zone_id
  vault_token = var.vault_token
}