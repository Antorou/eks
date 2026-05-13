module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.8"

  name = var.name_prefix
  cidr = var.vpc_cidr

  azs            = var.availability_zones
  public_subnets = var.public_subnet_cidrs

  private_subnets    = []
  enable_nat_gateway = false

  map_public_ip_on_launch = true
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  tags = {
    "kubernetes.io/cluster/${var.name_prefix}" = "shared"
  }
}
