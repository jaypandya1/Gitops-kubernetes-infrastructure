module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "boutique-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  # Cost-optimized: Single NAT Gateway
  enable_nat_gateway = true
  single_nat_gateway = true # Keep this as true for cost savings

  tags = {
    "kubernetes.io/cluster/boutique-cluster" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/boutique-cluster" = "shared"
    "kubernetes.io/role/elb"                 = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/boutique-cluster" = "shared"
    "kubernetes.io/role/internal-elb"        = "1"
  }
}
