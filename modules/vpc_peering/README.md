
# Route to VPC-B
resource "aws_route" "a_to_b_public" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = var.vpc_b_cidr
  vpc_peering_connection_id = var.pcx_ab_id
}

resource "aws_route" "a_to_b_private" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = var.vpc_b_cidr
  vpc_peering_connection_id = var.pcx_ab_id
}

# Route to VPC-C
resource "aws_route" "a_to_c_public" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = var.vpc_c_cidr
  vpc_peering_connection_id = var.pcx_ac_id
}

resource "aws_route" "a_to_c_private" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = var.vpc_c_cidr
  vpc_peering_connection_id = var.pcx_ac_id
}


# Add Routes in VPC-B Route Tables
resource "aws_route" "b_to_a_public" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = var.vpc_a_cidr
  vpc_peering_connection_id = var.pcx_ab_id
}

resource "aws_route" "b_to_a_private" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = var.vpc_a_cidr
  vpc_peering_connection_id = var.pcx_ab_id
}


#Add Routes in VPC-C Route Tables
resource "aws_route" "c_to_a_public" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = var.vpc_a_cidr
  vpc_peering_connection_id = var.pcx_ac_id
}

resource "aws_route" "c_to_a_private" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = var.vpc_a_cidr
  vpc_peering_connection_id = var.pcx_ac_id
}
