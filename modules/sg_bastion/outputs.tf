output "bastion_sg_id" {
  description = "ID of the public security group"
  value       = aws_security_group.sg_bastion.id
}

