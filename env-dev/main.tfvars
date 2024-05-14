env = "dev"
instance_type = "t3.small"
zone_id = "Z05016193JAPZUY12R8OR"

#    VPC
vpc_ip_block = "10.10.0.0/24"
#subnet_ip_block = "10.10.0.0/24"
default_vpc_id = "vpc-0b6dc4e5c7774329d"
default_vpc_ip_block = "172.31.0.0/16"
default_rtb_id = "rtb-0cf6d1c759914c89c"

fe_subnets = ["10.10.0.0/27", "10.10.0.32/27"]
be_subnets = ["10.10.0.64/27", "10.10.0.96/27"]
db_subnets = ["10.10.0.128/27", "10.10.0.160/27"]
public_subnets = ["10.10.0.192/27", "10.10.0.224/27"]
availability_zones = ["us-east-1a", "us-east-1b"]