
variable "admin_role_principals" {
  description = "List of service principals for admin role"
  type        = list(string)
  default     = ["ec2.amazonaws.com"]
}




