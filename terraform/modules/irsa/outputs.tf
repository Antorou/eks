output "role_arn" {
  description = "ARN of the IAM role — annotate your Kubernetes ServiceAccount with this."
  value       = aws_iam_role.app.arn
}
