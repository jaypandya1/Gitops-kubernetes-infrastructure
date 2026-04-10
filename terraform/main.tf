module "boutique_eks" {
  # Point to the folder where your reusable module lives
  source = "./modules/eks"

  cluster_name           = "boutique-cluster"
  kubernetes_version     = "1.31" # Valid version here!
  endpoint_public_access = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets # Nodes in private subnets for better security
  control_plane_subnet_ids = module.vpc.private_subnets

  # THIS is where you put your specific node group!
  eks_managed_node_groups = {
    boutique_nodes = {
      desired_size   = 5
      max_size       = 6
      min_size       = 5
      instance_types = ["t3.small"]
      # Add your disk sizes here if needed!
    }
  }

  # THIS is where you define your specific addons
  cluster_addons = {
    coredns = {}
    vpc-cni = {
      before_compute = true
    }
    kube-proxy = {}
  }
}