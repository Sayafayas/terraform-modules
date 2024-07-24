resource "aws_security_group" "runner_sg" {
  name        = "Runner Security Group"
  description = "Allow SSH from public_subnet"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = tolist(data.terraform_remote_state.network.outputs.public_subnet_cidrs) # Allow SSH from k8s (adjust as necessary)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "${var.common_tags["Project"]} Runner SecurityGroup" })
}

resource "aws_security_group" "k8s_sg" {
  name        = "k8s Security Group"
  description = "Allow SSH, HTTPS, and internal communication"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id # This need to be added since AWS Provider v4.29+ to set VPC id

  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = concat(var.ingress_cidr_blocks, tolist(data.terraform_remote_state.network.outputs.private_subnet_cidrs))
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

resource "aws_security_group" "rds_sg" {
  name        = "RDS Security Group"
  description = "Allow ingress traffic from VPC subnet"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = tolist(data.terraform_remote_state.network.outputs.public_subnet_cidrs) # Allow traffic from the k8s public subnet
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "${var.common_tags["Project"]} RDS SecurityGroup" })
}
