

# # IAM Module
module "iam" {
  source = "../modules/iam"

  # Role Services Allowed
  admin_role_principals          = ["ec2.amazonaws.com"]  # Only include the services that actually need to assume the role.


}


module "ssm" {
  source         = "../modules/ssm"

  key_path_parameter_name   = "/kp/path"
  key_name_parameter_name   = "/kp/name"


}




module "vpc_a" {
  source               = "../modules/vpc"
  ResourcePrefix       = "A"
  availability_zones   = ["us-east-1a", "us-east-1b"]
  vpc_cidr             = "10.16.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
  public_subnet_cidr   = ["10.16.1.0/24"]
  private_subnet_cidr  = ["10.16.2.0/24"]
  public_ip_on_launch  = true

  


}

module "vpc_b" {
  source               = "../modules/vpc"
  ResourcePrefix       = "B"
  availability_zones   = ["us-east-1a", "us-east-1b"]
  vpc_cidr             = "10.20.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
  public_subnet_cidr   = ["10.20.1.0/24"]
  private_subnet_cidr  = ["10.20.2.0/24"]
  public_ip_on_launch  = true

  
}



module "vpc_c" {
  source               = "../modules/vpc"
  ResourcePrefix       = "C"
  availability_zones   = ["us-east-1a", "us-east-1b"]
  vpc_cidr             = "10.20.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
  public_subnet_cidr   = ["10.20.3.0/24"]
  private_subnet_cidr = ["10.20.0.16/28"]
  public_ip_on_launch  = true

}

module "p_ab" {
  source = "../modules/vpc_peering"

  name = "P-A-B"

  requester_vpc_id         = module.vpc_a.vpc_id
  accepter_vpc_id          = module.vpc_b.vpc_id

  requester_route_table_id = module.vpc_a.public_rt_id
  accepter_route_table_id  = module.vpc_b.private_rt_id

  # A → B
  requester_routes = [
    "10.20.0.0/16"
  ]

  # B → A
  accepter_routes = [
    "10.16.0.0/16"
  ]

  # MUST be a map per updated module
  requester_host_routes = [
  "${values(module.ec2_b.private_instance_private_ips)[0]}/32"
]

  accepter_host_routes = [
    "${values(module.ec2_a.public_instance_private_ips)[0]}/32"
  ]

  auto_accept = true
}



module "p_ac" {
  source = "../modules/vpc_peering"

  name = "P-A-C"

  requester_vpc_id         = module.vpc_a.vpc_id
  accepter_vpc_id          = module.vpc_c.vpc_id

  requester_route_table_id = module.vpc_a.public_rt_id
  accepter_route_table_id  = module.vpc_c.private_rt_id

  requester_routes = [
    "10.20.0.20/32"
  ]
  accepter_routes = []


  requester_host_routes = [
   "${values(module.ec2_c.private_instance_private_ips)[0]}/32"
    ]
  accepter_host_routes = [
    "${values(module.ec2_a.public_instance_private_ips)[0]}/32"
  ]
}



module "sg_bastion" {
  source = "../modules/sg_bastion"
  name   = "bastion-sg"
  vpc_id = module.vpc_a.vpc_id

  allowed_ssh_cidrs = ["10.20.0.0/16"]
}

module "sg_intervpc_a" {
  source            = "../modules/sg_intervpc"
  name              = "intervpc-a"
  vpc_id            = module.vpc_a.vpc_id
  allowed_vpc_cidrs = [
    module.vpc_b.vpc_cidr,
    module.vpc_c.vpc_cidr
  ]
}

module "sg_intervpc_b" {
  source            = "../modules/sg_intervpc"
  name              = "intervpc-b"
  vpc_id            = module.vpc_b.vpc_id
  allowed_vpc_cidrs = [
    module.vpc_a.vpc_cidr,
    module.vpc_c.vpc_cidr
  ]
}

module "sg_intervpc_c" {
  source            = "../modules/sg_intervpc"
  name              = "intervpc-c"
  vpc_id            = module.vpc_c.vpc_id
  allowed_vpc_cidrs = [
    module.vpc_a.vpc_cidr,
    module.vpc_b.vpc_cidr
  ]
}

module "sg_instance_private_b" {
  source         = "../modules/sg_private_instance"
  name           = "instance-private-b"
  vpc_id         = module.vpc_b.vpc_id
  bastion_sg_id  = module.sg_bastion.bastion_sg_id
  intervpc_sg_id = module.sg_intervpc_b.sg_intervpc_id
}

module "sg_instance_private_c" {
  source         = "../modules/sg_private_instance"
  name           = "instance-private-c"
  vpc_id         = module.vpc_c.vpc_id
  bastion_sg_id  = module.sg_bastion.bastion_sg_id
  intervpc_sg_id = module.sg_intervpc_c.sg_intervpc_id
}


# EC2 to test VPC-C
module "ec2_c" {
  source = "../modules/ec2"

  ResourcePrefix             = "VPC-C-Test"
  ami_ids                    = ["ami-0fa3fe0fa7920f68e"]
  ami_names                  = ["AL2023"]
  instance_types             = ["t2.micro"]
  key_name                   = module.ssm.key_name_parameter_value
  instance_profile_name      = module.iam.rbac_instance_profile_name

  public_instance_count      = [0]
  private_instance_count     = [1]   # <-- create 1 instance in VPC-C

  tag_value_private_instances = [
    [
      {
        Name = "c-longest-prefix-tester"
        Role = "RoutingTest"
      }
    ]
  ]

  tag_value_public_instances = []
  vpc_id                     = module.vpc_c.vpc_id
  public_subnet_ids          = []
  private_subnet_ids         = [module.vpc_c.private_subnet_ids[0]] # <-- choose the subnet that contains 10.20.0.20
  public_sg_id               = null
  private_sg_id              = module.sg_instance_private_c.private_instance_sg_id
  volume_size                = 8
  volume_type                = "gp3"
}


module "ec2_a" {
  source = "../modules/ec2"

  ResourcePrefix        = "VPC-A-Test"
  ami_ids               = ["ami-0fa3fe0fa7920f68e"]
  ami_names             = ["AL2023"]
  instance_types        = ["t2.micro"]
  key_name              = module.ssm.key_name_parameter_value
  instance_profile_name = module.iam.rbac_instance_profile_name

  public_instance_count  = [1]
  private_instance_count = [0]

  tag_value_public_instances = [
    [
      {
        Name = "test-a"
        Role = "RoutingTest"
      }
    ]
  ]

  tag_value_private_instances = []

  vpc_id            = module.vpc_a.vpc_id
  public_subnet_ids = [module.vpc_a.public_subnet_ids[0]]   
  private_subnet_ids = []
  public_sg_id      = module.sg_bastion.bastion_sg_id
  private_sg_id     = null

  volume_size = 8
  volume_type = "gp3"
}



module "ec2_b" {
  source = "../modules/ec2"

  ResourcePrefix             = "VPC-B-Test"
  ami_ids                    = ["ami-0fa3fe0fa7920f68e"]
  ami_names                  = ["AL2023"]
  instance_types             = ["t2.micro"]
  key_name                   = module.ssm.key_name_parameter_value
  instance_profile_name      = module.iam.rbac_instance_profile_name

  public_instance_count      = [0]
  private_instance_count     = [1]   # <-- create 1 instance in VPC-C

  tag_value_private_instances = [
    [
      {
        Name = "testing-b"
        Role = "RoutingTest"
      }
    ]
  ]

  tag_value_public_instances = []
  vpc_id                     = module.vpc_b.vpc_id
  public_subnet_ids          = []
  private_subnet_ids         = [module.vpc_b.private_subnet_ids[0]] # <-- choose the subnet that contains 10.20.0.20
  public_sg_id               = null
  private_sg_id              = module.sg_instance_private_b.private_instance_sg_id
  volume_size                = 8
  volume_type                = "gp3"
}
