variable "name_prefix" {
  description = "Prefix for the IAM role name."
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the EKS OIDC provider — identifies the issuer in the trust policy."
  type        = string
}

variable "oidc_provider_url" {
  description = "URL of the EKS OIDC provider — used to scope the trust to a specific service account."
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket the app is allowed to access."
  type        = string
}

variable "app_namespace" {
  description = "Kubernetes namespace where the app service account lives."
  type        = string
}

variable "app_service_account" {
  description = "Name of the Kubernetes service account that will assume this role."
  type        = string
  default     = "backend"
}
