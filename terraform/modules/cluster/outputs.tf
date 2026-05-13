output "endpoint" {
  description = "EKS API server endpoint — used by Helm and Kubernetes providers."
  value       = module.eks.cluster_endpoint
}

output "ca_certificate" {
  description = "Base64-encoded cluster CA — used to verify the API server TLS cert."
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_name" {
  description = "Cluster name — used in kubeconfig and IAM trust policies."
  value       = module.eks.cluster_name
}

output "node_security_group_id" {
  description = "SG attached to worker nodes — RDS will allow inbound from this."
  value       = module.eks.node_security_group_id
}

output "oidc_provider_arn" {
  description = "ARN of the OIDC provider — used by the irsa module to build trust policies."
  value       = module.eks.oidc_provider_arn
}

output "oidc_provider_url" {
  description = "URL of the OIDC provider — used to scope the IAM trust to a specific service account."
  value       = module.eks.cluster_oidc_issuer_url
}
