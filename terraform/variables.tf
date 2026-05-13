variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
  default     = "eu-west-3"
}

variable "project_name" {
  description = "Short prefix used in every resource name (e.g. 'obs-lab')."
  type        = string
  default     = "obs-lab"
}

variable "environment" {
  description = "Deployment environment — drives naming and tagging."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "AZs to deploy into. EKS requires at least 2."
  type        = list(string)
  default     = ["eu-west-3a", "eu-west-3b"]
}

variable "public_subnet_cidrs" {
  description = "One public subnet CIDR per AZ. Length must match availability_zones."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS control plane."
  type        = string
  default     = "1.30"
}

variable "node_instance_type" {
  description = "EC2 instance type for the managed node group."
  type        = string
  default     = "t3.medium"
}

variable "node_desired_size" {
  description = "Desired number of nodes in the managed node group."
  type        = number
  default     = 1
}

variable "db_name" {
  description = "Name of the PostgreSQL database."
  type        = string
  default     = "recipes"
}

variable "db_username" {
  description = "Master username for RDS."
  type        = string
  default     = "appuser"
}

variable "db_instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t3.micro"
}
