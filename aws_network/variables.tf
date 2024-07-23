variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = ""
  type        = string
}

variable "public_subnet_cidrs" {
  description = "The CIDR block for the public subnets"
  type        = list(string)
  default     = []
}

variable "private_subnet_cidrs" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
  default     = []
}

variable "enable_detailed_monitoring" {
  type    = bool
  default = false
}

variable "availability_zones" {
  description = "A list of availability zones"
  type        = list(string)
}

variable "common_tags" {
  description = "Common Tags to apply to all resources"
  type        = map(any)
  default = {
  }
}
