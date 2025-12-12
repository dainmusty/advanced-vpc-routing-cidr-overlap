variable "name" {
  type = string
}

variable "requester_vpc_id" {
  type = string
}
variable "accepter_vpc_id" {
  type = string
}

variable "requester_route_table_id" {
  type = string
}
variable "accepter_route_table_id" {
  type = string
}

# generic CIDR lists for each side (can be /16, /24 etc)
variable "requester_routes" {
  type    = list(string)
  default = []
}

variable "accepter_routes" {
  type    = list(string)
  default = []
}

# host-specific /32 routes to be added into each side's RT if needed
variable "requester_host_routes" {
  type    = list(string)
  default = []
  description = "List of host (/32) CIDRs to add into requester route table (e.g. if accepter needs specific host routes)"
}

variable "accepter_host_routes" {
  type    = list(string)
  default = []
  description = "List of host (/32) CIDRs to add into accepter route table (e.g. A's host IP /32 to be added into C RT)"
}

variable "auto_accept" {
  type    = bool
  default = true
}
