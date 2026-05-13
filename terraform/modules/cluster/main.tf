module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.11"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version
  vpc_id          = var.vpc_id
  subnet_ids      = var.subnet_ids

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true
  enable_irsa                              = true

  eks_managed_node_groups = {
    main = {
      instance_types = [var.node_instance_type]
      capacity_type  = "SPOT"
      min_size       = 1
      max_size       = var.node_desired_size + 1
      desired_size   = var.node_desired_size
    }
  }
}