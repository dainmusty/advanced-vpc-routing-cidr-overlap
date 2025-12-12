resource "aws_security_group" "sg_intervpc" {
  name        = var.name
  description = "Inter-VPC Communication SG"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.allowed_vpc_cidrs
    content {
      description = "Allow all traffic between VPCs"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
