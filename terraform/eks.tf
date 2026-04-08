module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "boutique-cluster"
  kubernetes_version = "1.33"

  # 1. Networking: Linking to the VPC module
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  # 2. Access: Grants your AWS IAM user admin access to the cluster
  enable_cluster_creator_admin_permissions = true

  # 3. Compute: The Worker Nodes
  eks_managed_node_groups = {
    boutique_nodes = {
      min_size     = 2
      max_size     = 3
      desired_size = 2

      # t3.medium provides 2 vCPUs and 4GB RAM
      # balance of cost and power for our 11 microservices.
      instance_types = ["t3.medium"]
    }
  }
}