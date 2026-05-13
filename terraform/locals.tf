locals {
  name_prefix             = "${var.project_name}-${var.environment}"
  cluster_name            = local.name_prefix
  app_namespace           = "default"
  monitoring_namespace    = "monitoring"
  prometheus_release_name = "kube-prometheus-stack"
}
