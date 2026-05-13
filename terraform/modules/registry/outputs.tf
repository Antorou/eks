output "repository_urls" {
  description = "Map of service name → ECR URL. e.g. { backend = '123456789.dkr.ecr.eu-west-3.amazonaws.com/obs-lab/backend' }"
  value       = { for k, v in aws_ecr_repository.this : k => v.repository_url }
}
