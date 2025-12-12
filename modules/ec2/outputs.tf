# output "public_instance_ids" {
#   description = "List of public EC2 instance IDs"
#   value       = [for instance in aws_instance.public : instance.id]
# }
# output "private_instance_ids" {
#   description = "List of private EC2 instance IDs"
#   value       = [for instance in aws_instance.private : instance.id]
# }


# If your ec2 module creates multiple instances and returns a list, adapt accordingly.
# Example output for first public instance private IP:
output "public_instance_private_ips" {
  value = {
    for name, inst in aws_instance.public :
    name => inst.private_ip
  }
}


# If you only expect one bastion in ec2_a, you can reference [0] in the root:
# module.ec2_a.public_instance_private_ips[0]

output "private_instance_private_ips" {
  value = {
    for name, inst in aws_instance.private :
    name => inst.private_ip
  }
}

