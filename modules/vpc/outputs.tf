output "vps_id" {
  value = aws_vpc.main.id
}

output "fe_subnets" {
  value = aws_subnet.fe.*.id
}

output "be_subnets" {
  value = aws_subnet.be.*.id
}

output "db_subnets" {
  value = aws_subnet.db.*.id
}

output "public_subnets" {
  value = aws_subnet.public.*.id
}
