output "key_path_parameter_value" {
  description = "The value of the key SSM parameter"
  value       = data.aws_ssm_parameter.key_path_parameter_name.value
  sensitive = true
}

output "key_name_parameter_value" {
  description = "The value of the key name SSM parameter"
  value       = data.aws_ssm_parameter.key_name_parameter_name.value
  sensitive = true
}