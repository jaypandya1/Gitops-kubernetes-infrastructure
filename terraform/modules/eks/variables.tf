variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version to use for the EKS cluster (e.g., 1.31)"
  type        = string
}

variable "cluster_addons" {
  description = "Map of cluster addon configurations to enable for the cluster."
  type        = any
  default     = {} # Empty default! Let the caller decide.
}

variable "endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "enable_cluster_creator_admin_permissions" {
  description = "Indicates whether or not to add the cluster creator as an administrator"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "ID of the VPC where the cluster will be provisioned"
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs where the nodes/node groups will be provisioned"
  type        = list(string)
}

variable "control_plane_subnet_ids" {
  description = "A list of subnet IDs where the EKS cluster control plane ENIs will be provisioned"
  type        = list(string)
}

variable "eks_managed_node_groups" {
  description = "Map of EKS managed node group definitions to create"
  type        = any
  default     = {} # Empty default!
}