
data "aws_ssm_parameter" "key_path_parameter_name" {
  name = var.key_path_parameter_name
  with_decryption = true
}

data "aws_ssm_parameter" "key_name_parameter_name" {
  name = var.key_name_parameter_name
  with_decryption = true
}

