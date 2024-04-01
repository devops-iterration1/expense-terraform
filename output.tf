variable "env" {
  default = ""
}
output "test_message" {
  value = "env from tfvars file - ${var.env}"
}

