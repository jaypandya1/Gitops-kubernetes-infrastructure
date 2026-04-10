module "eks" {
source  = "terraform-aws-modules/eks/aws"
version = "21.17.1"

   name        = var.cluster_name
  kubernetes_version = var.kubernetes_version

  addons = var.cluster_addons
   
  endpoint_public_access = var.endpoint_public_access

  #Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = var.enable_cluster_creator_admin_permissions

  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnet_ids
  control_plane_subnet_ids = var.control_plane_subnet_ids

  # EKS Managed Node Group(s)
  eks_managed_node_groups = var.eks_managed_node_groups

  tags = {
    Environment = "dev"
  }

 }