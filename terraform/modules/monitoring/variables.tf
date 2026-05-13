variable "release_name" {
  description = "Helm release name — used as the label prefix for ServiceMonitors."
  type        = string
}

variable "monitoring_namespace" {
  description = "Kubernetes namespace to deploy the stack into."
  type        = string
}

variable "grafana_admin_password" {
  description = "Grafana admin password. Inject via TF_VAR_grafana_admin_password."
  type        = string
  sensitive   = true
  default     = "admin"
}
