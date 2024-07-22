variable "aws_region" {
  description = "The AWS region to create resources in"
  default     = "eu-central-1"
}

variable "key_pair_name" {
  description = "The name of the key pair to use for SSH access"
  default     = ""
}

variable "db_instance_class" {
  description = "The instance class for the RDS instance"
  default     = "db.t4g.micro"
}

variable "db_engine" {
  description = "The database engine for the RDS instance"
  default     = "mysql"
}

variable "db_engine_version" {
  description = "The version of the database engine"
  default     = "8.0.37"
}

variable "db_username" {
  description = "The username for the RDS instance"
  default     = ""
}

variable "db_password" {
  description = "The password for the RDS instance"
  default     = ""
}

variable "db_allocated_storage" {
  description = "The allocated storage for the RDS instance"
  default     = 5
}

variable "instance_type" {
  description = "The type of instance to use for the EC2 instance"
  default     = "t2.micro"
}

variable "runner_instance_type" {
  description = "The instance type for the GitHub Actions runner"
  default     = "t3.medium"
}


variable "enable_detailed_monitoring" {
  type    = bool
  default = false
}

variable "common_tags" {
  description = "Common Tags to apply to all resources"
  type        = map(any)
  default = {
  }
}
