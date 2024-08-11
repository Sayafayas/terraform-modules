variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "server_certificate_arn" {
  description = "ARN of the server certificate for the Client VPN endpoint"
  type        = string
}

variable "client_certificate_arn" {
  description = "ARN of the client certificate for the Client VPN endpoint"
  type        = string
}

variable "client_cidr_block" {
  description = "The CIDR block to be used by the Client VPN endpoint"
  type        = string
}

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
