output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "private_rt_id" {
  value = aws_route_table.private_rt.id
}

output "public_rt_id" {
  value = aws_route_table.public_rt.id
}

output "public_subnet_ids" {
  value = [for subnet in aws_subnet.public_subnet : subnet.id]
}

output "private_subnet_ids" {
  value = [for subnet in aws_subnet.private_subnet : subnet.id]
}

output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}
