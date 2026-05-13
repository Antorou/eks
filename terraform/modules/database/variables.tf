variable "name_prefix" {
  description = "Prefix for all resource names."
  type        = string
}

variable "vpc_id" {
  description = "VPC where the RDS security group will be created."
  type        = string
}

variable "subnet_ids" {
  description = "Subnets for the DB subnet group."
  type        = list(string)
}

variable "node_sg_id" {
  description = "Security group of EKS worker nodes — only source allowed to reach port 5432."
  type        = string
}

variable "db_name" {
  description = "Initial database name."
  type        = string
}

variable "db_username" {
  description = "Master DB username."
  type        = string
}

variable "db_instance_class" {
  description = "RDS instance class."
  type        = string
}
