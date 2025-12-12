output "peering_id" {
  value = aws_vpc_peering_connection.vpc_peering.id
}

# Optional: expose the created routes count for debugging
output "requester_routes_created" {
  value = [for r in aws_route.requester_routes : r.id]
  sensitive = false
}

output "accepter_routes_created" {
  value = [for r in aws_route.accepter_routes : r.id]
  sensitive = false
}
