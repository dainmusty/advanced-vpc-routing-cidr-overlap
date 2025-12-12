resource "aws_security_group" "sg_private_instance" {
  name        = var.name
  description = "Private Instances SG"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [var.bastion_sg_id]
  }

  ingress {
    description = "ICMP from bastion"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    security_groups = [var.bastion_sg_id]
  }

  ingress {
    description = "Internal traffic from other VPCs"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [var.intervpc_sg_id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
