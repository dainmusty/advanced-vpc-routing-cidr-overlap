output "private_instance_sg_id" {
  description = "ID of the private instance security group"
  value       = aws_security_group.sg_private_instance.id
}

 