module "networking" {
  source = "./modules/networking"

  name_prefix         = local.name_prefix
  vpc_cidr            = var.vpc_cidr
  availability_zones  = var.availability_zones
  public_subnet_cidrs = var.public_subnet_cidrs
}

module "cluster" {
  source = "./modules/cluster"

  name_prefix        = local.name_prefix
  cluster_name       = local.cluster_name
  kubernetes_version = var.kubernetes_version
  node_instance_type = var.node_instance_type
  node_desired_size  = var.node_desired_size
  vpc_id             = module.networking.vpc_id
  subnet_ids         = module.networking.public_subnet_ids
}

module "registry" {
  source = "./modules/registry"

  project_name = var.project_name
}

module "storage" {
  source = "./modules/storage"

  name_prefix = local.name_prefix
}

module "database" {
  source = "./modules/database"

  name_prefix       = local.name_prefix
  vpc_id            = module.networking.vpc_id
  subnet_ids        = module.networking.public_subnet_ids
  node_sg_id        = module.cluster.node_security_group_id
  db_name           = var.db_name
  db_username       = var.db_username
  db_instance_class = var.db_instance_class
}

module "irsa" {
  source = "./modules/irsa"

  name_prefix         = local.name_prefix
  oidc_provider_arn   = module.cluster.oidc_provider_arn
  oidc_provider_url   = module.cluster.oidc_provider_url
  s3_bucket_arn       = module.storage.bucket_arn
  app_namespace       = local.app_namespace
}

module "monitoring" {
  source = "./modules/monitoring"

  release_name         = local.prometheus_release_name
  monitoring_namespace = local.monitoring_namespace

  depends_on = [module.cluster]
}
