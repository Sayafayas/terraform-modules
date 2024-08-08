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

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "allow_ports" {
  description = "List of ports to allow ingress for k8s security group"
  type        = list(number)
}

variable "ingress_cidr_blocks" {
  description = "List of CIDR blocks to allow ingress traffic for k8s security group"
  type        = list(string)
}
