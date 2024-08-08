# Fetch the VPC created by the network module
data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["${var.project} Main VPC"]
  }

  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }
}

# Fetch the public subnets created by the network module
data "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  filter {
    name   = "tag:Name"
    values = ["${var.project} Public Subnet-${count.index + 1}"]
  }

  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }

  vpc_id = data.aws_vpc.main.id
}

# Fetch the private subnets created by the network module
data "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  filter {
    name   = "tag:Name"
    values = ["${var.project} Private Subnet-${count.index + 1}"]
  }

  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }

  vpc_id = data.aws_vpc.main.id
}

# Create the runner security group
resource "aws_security_group" "runner_sg" {
  name        = "Runner Security Group"
  description = "Allow SSH from public_subnet"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [for s in data.aws_subnet.public : s.cidr_block] # Allow SSH from k8s (adjust as necessary)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "${var.common_tags["Project"]} Runner SecurityGroup" })
}

# Create the k8s security group
resource "aws_security_group" "k8s_sg" {
  name        = "k8s Security Group"
  description = "Allow SSH, HTTPS, and internal communication"
  vpc_id      = data.aws_vpc.main.id # This needs to be added since AWS Provider v4.29+ to set VPC id

  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = concat(var.ingress_cidr_blocks, [for s in data.aws_subnet.private : s.cidr_block])
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "${var.common_tags["Project"]} k8s SecurityGroup" })
}

# Create the RDS security group
resource "aws_security_group" "rds_sg" {
  name        = "RDS Security Group"
  description = "Allow ingress traffic from VPC subnet"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [for s in data.aws_subnet.private : s.cidr_block] # Allow traffic from the k8s private subnet
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "${var.common_tags["Project"]} RDS SecurityGroup" })
}
