resource "aws_vpc" "main" {
  cidr_block = var.vpc_ip_block

  tags = {
    Name = "${var.env}-vpc"
  }
}

resource "aws_subnet" "fe" {
  count = length(var.fe_subnets)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.fe_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.env}-fe-subnet-${count.index}"
  }
}

resource "aws_vpc_peering_connection" "main" {
  peer_vpc_id   = var.default_vpc_id
  vpc_id        = aws_vpc.main.id
  auto_accept = true

  tags = {
    Name = "${var.env}-vpc-peer-default-vpc"
  }
}

resource "aws_route" "main" {
  route_table_id            = aws_vpc.main.default_route_table_id
  destination_cidr_block    = var.default_vpc_ip_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}

resource "aws_route" "default" {
  route_table_id            = var.default_rtb_id
  destination_cidr_block    = var.vpc_ip_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}