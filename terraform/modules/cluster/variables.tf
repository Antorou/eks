variable "name_prefix" {
  description = "Prefix for all resource names."
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name — also used in IAM trust policies."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the control plane."
  type        = string
}

variable "node_instance_type" {
  description = "EC2 instance type for worker nodes."
  type        = string
}

variable "node_desired_size" {
  description = "Desired number of worker nodes."
  type        = number
}

variable "vpc_id" {
  description = "VPC to deploy the cluster into."
  type        = string
}

variable "subnet_ids" {
  description = "Subnets for the node group."
  type        = list(string)
}
