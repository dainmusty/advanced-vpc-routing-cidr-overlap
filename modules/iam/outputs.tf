output "admin_role_arn" {
  description = "ARN of the admin role"
  value       = aws_iam_role.admin_role.arn
}

output "rbac_instance_profile_name" {
  description = "Name of the instance profile"
  value       = aws_iam_instance_profile.rbac_instance_profile.name
}
