resource "aws_security_group" "main" {
  name        = "${var.component}-${var.env}-sg"
  description = "${var.component}-${var.env}-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.component}-${var.env}-sg"
  }
}

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.my-ami.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.main.id]
  subnet_id = var.subnets[0]

  tags = {
    Name = var.component
    monitor = "yes"
    env = var.env
  }

  instance_market_options{
    market_type = "spot"
    spot_options{
      instance_interruption_behavior = "stop"
      spot_instance_type = "persistent"
    }
  }
}

resource "null_resource" "provision_ansible" {
  provisioner "remote-exec" {
    connection {
      type = "ssh"
      host = aws_instance.ec2.public_ip
      user = jsondecode(data.vault_generic_secret.ssh.data_json).ansible_user
      password = jsondecode(data.vault_generic_secret.ssh.data_json).ansible_password
    }
    inline = [
      "sudo pip install ansible hvac",
      "ansible-pull -i localhost, -U https://github.com/devops-iterration1/expense-ansible get-secrets.yml -e vault_token=${var.vault_token} -e env=${var.env} -e role_name=${var.component}",
      "ansible-pull -i localhost, -U https://github.com/devops-iterration1/expense-ansible expense-setup.yml -e env=${var.env} -e role_name=${var.component} -e @~/ssh-secrets.json -e @~/app-secrets.json",
      "rm -f ~/ssh-secrets.json ~/app-secrets.json"
    ]
  }
}

resource "aws_route53_record" "A-record" {
  name    = "${var.component}-${var.env}"
  type    = "A"
  zone_id = var.zone_id
  records = [aws_instance.ec2.private_ip]
  ttl     = 30
}