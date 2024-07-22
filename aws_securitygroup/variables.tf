variable "enable_detailed_monitoring" {
  type    = bool
  default = false
}

variable "ingress_cidr_blocks" {
  description = "List of CIDR blocks for the security group ingress rules"
  type        = list(string)
  default     = []
}

variable "allow_ports" {
  description = "List of Ports to open for server"
  type        = list(any)
  default     = []
}

variable "common_tags" {
  description = "Common Tags to apply to all resources"
  type        = map(any)
  default = {
  }
}
