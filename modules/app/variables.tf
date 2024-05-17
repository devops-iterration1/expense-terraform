variable "instance_type" {}
variable "component" {}
variable "env" {}
variable "zone_id" {}
variable "vault_token" {}

variable "vpc_id" {}
variable "subnets" {}

variable "lb_type" {
  default = null
}
variable "lb_needed" {
  default = false
}
variable "lb_subnets" {
  default = null
}
variable "app_port" {
  default = null
}

variable "bastion_nodes" {}
variable "prometheus_nodes" {}
variable "server_sg_cidr" {}
variable "lb_sg_cidr" {
  default = []
}