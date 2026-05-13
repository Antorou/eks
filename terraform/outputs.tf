output "cluster_name" {
  description = "Run: aws eks update-kubeconfig --name <value> --region <region>"
  value       = module.cluster.cluster_name
}

output "ecr_repository_urls" {
  description = "Map of service → ECR URL. Use these in your docker push / CI pipeline."
  value       = module.registry.repository_urls
}

output "rds_endpoint" {
  description = "PostgreSQL connection endpoint. Format: host:port"
  value       = module.database.endpoint
}

output "rds_password" {
  description = "Generated RDS password — retrieve with: terraform output -raw rds_password"
  value       = module.database.db_password
  sensitive   = true
}

output "s3_bucket_name" {
  description = "App S3 bucket name (includes random suffix)."
  value       = module.storage.bucket_name
}

output "app_iam_role_arn" {
  description = "Annotate your backend ServiceAccount with this ARN to enable IRSA."
  value       = module.irsa.role_arn
}

output "grafana_port_forward" {
  description = "Command to open Grafana locally."
  value       = "kubectl port-forward svc/${module.monitoring.grafana_service_name} 3000:80 -n ${module.monitoring.monitoring_namespace}"
}
