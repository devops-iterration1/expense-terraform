# VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_ip_block

  tags = {
    Name = "${var.env}-vpc"
  }
}

# peering connection between default-vpc(workstation) to main-vpc
resource "aws_vpc_peering_connection" "main" {
  peer_vpc_id   = var.default_vpc_id
  vpc_id        = aws_vpc.main.id
  auto_accept = true

  tags = {
    Name = "${var.env}-vpc-peer-default-vpc"
  }
}

# internet gateway for main-vpc
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env}-igw"
  }
}

# public subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnets)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.env}-public-subnet-${count.index}"
  }
}

# public route table
resource "aws_route_table" "public" {
  count = length(var.public_subnets)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.default_vpc_ip_block
    vpc_peering_connection_id = aws_vpc_peering_connection.main.id
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env}-public-rt-${count.index}"
  }
}

# ip
resource "aws_eip" "ngw" {
  count  = length(var.public_subnets)
  domain   = "vpc"
}

# nat gateway
resource "aws_nat_gateway" "ngw" {
  count  = length(var.public_subnets)
  allocation_id = aws_eip.ngw[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "${var.env}-ngw-${count.index + 1}"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

############### FE subnet
resource "aws_subnet" "fe" {
  count = length(var.fe_subnets)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.fe_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.env}-fe-subnet-${count.index}"
  }
}

# FE route table
resource "aws_route_table" "frontend" {
  count  = length(var.fe_subnets)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block                = var.default_vpc_ip_block
    vpc_peering_connection_id = aws_vpc_peering_connection.main.id
  }

  route {
    cidr_block                = "0.0.0.0/0"
    nat_gateway_id            = aws_nat_gateway.ngw[count.index].id
  }

  tags = {
    Name = "${var.env}-fe-rt-${count.index + 1}"
  }

}

# FE route table association
resource "aws_route_table_association" "frontend" {
  count          = length(var.fe_subnets)
  subnet_id      = aws_subnet.fe[count.index].id
  route_table_id = aws_route_table.frontend[count.index].id
}



########### BE subnet
resource "aws_subnet" "be" {
  count = length(var.be_subnets)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.be_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.env}-be-subnet-${count.index}"
  }
}

# BE route table
resource "aws_route_table" "backend" {
  count  = length(var.be_subnets)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block                = var.default_vpc_ip_block
    vpc_peering_connection_id = aws_vpc_peering_connection.main.id
  }

  route {
    cidr_block                = "0.0.0.0/0"
    nat_gateway_id            = aws_nat_gateway.ngw[count.index].id
  }

  tags = {
    Name = "${var.env}-be-rt-${count.index + 1}"
  }

}

# BE route table association
resource "aws_route_table_association" "backend" {
  count          = length(var.be_subnets)
  subnet_id      = aws_subnet.be[count.index].id
  route_table_id = aws_route_table.backend[count.index].id
}

################ DB subnet
resource "aws_subnet" "db" {
  count = length(var.db_subnets)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.db_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.env}-db-subnet-${count.index}"
  }
}

# DB route table
resource "aws_route_table" "db" {
  count  = length(var.db_subnets)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block                = var.default_vpc_ip_block
    vpc_peering_connection_id = aws_vpc_peering_connection.main.id
  }

  route {
    cidr_block                = "0.0.0.0/0"
    nat_gateway_id            = aws_nat_gateway.ngw[count.index].id
  }

  tags = {
    Name = "${var.env}-db-rt-${count.index + 1}"
  }

}

# DB route table association
resource "aws_subnet" "public" {
  count = length(var.public_subnets)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.env}-public-subnet-${count.index}"
  }
}



#resource "aws_route" "main" {
#  route_table_id            = aws_vpc.main.default_route_table_id
#  destination_cidr_block    = var.default_vpc_ip_block
#  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
#}

resource "aws_route" "default-vpc" {
  route_table_id            = var.default_rtb_id
  destination_cidr_block    = var.vpc_ip_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}

