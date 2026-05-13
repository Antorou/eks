output "bucket_name" {
  description = "Final bucket name"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "Bucket ARN — used by the irsa module to scope the IAM policy."
  value       = aws_s3_bucket.this.arn
}
