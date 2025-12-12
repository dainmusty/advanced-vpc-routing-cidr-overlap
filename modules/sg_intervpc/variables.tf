variable "name" {}
variable "vpc_id" {}
variable "allowed_vpc_cidrs" {
  type = list(string)
}
