variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
}

variable "runner_instance_type" {
  description = "Instance type for the runner instance"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "k8s_public_ip" {
  description = "Public IP address for the k8s instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the k8s node"
  type        = string
}

variable "key_pair_name" {
  description = "Key pair name for SSH access"
  type        = string
}

variable "db_allocated_storage" {
  description = "Allocated storage for the RDS instance"
  type        = number
}

variable "db_engine" {
  description = "Database engine for the RDS instance"
  type        = string
}

variable "db_engine_version" {
  description = "Engine version for the RDS instance"
  type        = string
}

variable "db_instance_class" {
  description = "Instance class for the RDS instance"
  type        = string
}

variable "db_username" {
  description = "Username for the RDS instance"
  type        = string
}

variable "db_password" {
  description = "Password for the RDS instance"
  type        = string
  sensitive   = true
}

variable "user_data_base64" {
  description = "Base64 encoded user data script"
  type        = string
  default     = ""
}

