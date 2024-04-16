resource "aws_instance" "ec2" {
  ami           = data.aws_ami.my-ami.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [data.aws_security_group.my-sg.id]
  tags = {
    Name = var.component
    monitor = "yes"
    env = var.env
  }
}

resource "null_resource" "provision_ansible" {
  provisioner "remote-exec" {
    connection {
      type = "ssh"
      host = aws_instance.ec2.public_ip
      user = jsondecode(data.vault_generic_secret.ssh.data_json).uid
      password = jsondecode(data.vault_generic_secret.ssh.data_json).pwd
    }
    inline = [
      "sudo dnf install ansible -y",
      "ansible-pull -i localhost, -U https://github.com/devops-iterration1/expense-ansible get-secrets.yml -e vault_token=${var.vault_token} -e env=${var.env} -e role_name=${var.component}",
      "ansible-pull -i localhost, -U https://github.com/devops-iterration1/expense-ansible expense-setup.yml -e env=${var.env} -e role_name=${var.component} -e @ssh-secrets.json -e @app-secrets.json"
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