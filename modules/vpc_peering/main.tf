resource "aws_vpc_peering_connection" "vpc_peering" {
  vpc_id      = var.requester_vpc_id
  peer_vpc_id = var.accepter_vpc_id
  auto_accept = var.auto_accept

  tags = {
    Name = var.name
  }
}

# requester -> accepter generic CIDR routes
resource "aws_route" "requester_routes" {
  for_each = { for idx, cidr in var.requester_routes : idx => cidr }

  route_table_id            = var.requester_route_table_id
  destination_cidr_block    = each.value
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

# accepter -> requester generic CIDR routes
resource "aws_route" "accepter_routes" {
  for_each = { for idx, cidr in var.accepter_routes : idx => cidr }

  route_table_id            = var.accepter_route_table_id
  destination_cidr_block    = each.value
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

# requester host-specific /32 routes
resource "aws_route" "requester_host_routes" {
  for_each = { for idx, cidr in var.requester_host_routes : idx => cidr }

  route_table_id            = var.requester_route_table_id
  destination_cidr_block    = each.value
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

# accepter host-specific /32 routes
resource "aws_route" "accepter_host_routes" {
  for_each = { for idx, cidr in var.accepter_host_routes : idx => cidr }

  route_table_id            = var.accepter_route_table_id
  destination_cidr_block    = each.value
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}
