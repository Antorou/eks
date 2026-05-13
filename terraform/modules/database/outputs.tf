output "endpoint" {
  description = "RDS connection endpoint (host:port)."
  value       = aws_db_instance.this.endpoint
}

output "db_name" {
  description = "Database name — for app configuration."
  value       = aws_db_instance.this.db_name
}

output "db_password" {
  description = "Generated master password — retrieve with: terraform output -raw db_password"
  value       = random_password.db.result
  sensitive   = true
}
