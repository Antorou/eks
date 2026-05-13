output "grafana_service_name" {
  description = "Kubernetes service name for Grafana — use this for port-forwarding."
  value       = "${var.release_name}-grafana"
}

output "monitoring_namespace" {
  description = "Namespace where the stack was deployed."
  value       = kubernetes_namespace.monitoring.metadata[0].name
}
