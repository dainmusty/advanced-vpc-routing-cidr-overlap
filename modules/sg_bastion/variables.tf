variable "name" {}
variable "vpc_id" {}
variable "allowed_ssh_cidrs" {
  type = list(string)
}
