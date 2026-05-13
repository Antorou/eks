resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.monitoring_namespace
  }
}

resource "helm_release" "kube_prometheus_stack" {
  name       = var.release_name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "58.7.2"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  # Persist Grafana dashboards and Prometheus data across pod restarts
  set {
    name  = "grafana.persistence.enabled"
    value = "true"
  }

  set {
    name  = "grafana.adminPassword"
    value = var.grafana_admin_password
  }

  # Reduces resource usage — acceptable for a lab single-node cluster
  set {
    name  = "prometheus.prometheusSpec.retention"
    value = "24h"
  }

  set {
    name  = "alertmanager.enabled"
    value = "false"
  }
}
