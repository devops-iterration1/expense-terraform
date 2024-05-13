data "aws_ami" "my-ami" {
  owners = ["973714476881"]
  most_recent = true
  name_regex = "RHEL-9-DevOps-Practice"
}

#data "aws_security_group" "my-sg" {
#  name = "allow-all"
#}

data "vault_generic_secret" "ssh" {
  path = "exp-kv/common"
}