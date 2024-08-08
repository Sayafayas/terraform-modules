# Fetch the latest Amazon Linux AMI
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

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

# Fetch the security group IDs created by the security module
data "aws_security_group" "runner_sg" {
  filter {
    name   = "tag:Name"
    values = ["${var.project} Runner SecurityGroup"]
  }

  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }
}

data "aws_security_group" "k8s_sg" {
  filter {
    name   = "tag:Name"
    values = ["${var.project} k8s SecurityGroup"]
  }

  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }
}

data "aws_security_group" "rds_sg" {
  filter {
    name   = "tag:Name"
    values = ["${var.project} RDS SecurityGroup"]
  }

  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }
}

# Fetch the Elastic IP created by the network module
data "aws_eip" "k8s_ip" {
  filter {
    name   = "tag:Name"
    values = ["${var.project} k8s EIP"]
  }

  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }
}

# Create the runner instance in the private subnet
resource "aws_instance" "runner" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = var.runner_instance_type
  subnet_id                   = data.aws_subnet.private[0].id
  vpc_security_group_ids      = [data.aws_security_group.runner_sg.id]
  key_name                    = var.key_pair_name
  associate_public_ip_address = false

  tags = merge(var.common_tags, {
    Name = "${var.common_tags["Project"]} Runner"
  })
}

# Create the k8s node instance in the public subnet
resource "aws_instance" "k8s_node" {
  ami             = data.aws_ami.latest_amazon_linux.id
  instance_type   = var.instance_type
  subnet_id       = data.aws_subnet.public[0].id
  security_groups = [data.aws_security_group.k8s_sg.id]
  key_name        = var.key_pair_name

  user_data = var.user_data_base64

  tags = merge(var.common_tags, {
    Name = "${var.common_tags["Project"]} k8s-Node"
  })

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      ami,
      instance_type,
      security_groups,
    ]
  }
}

# Associate the Elastic IP with the k8s node instance
resource "aws_eip_association" "k8s_eip_assoc" {
  instance_id   = aws_instance.k8s_node.id
  allocation_id = data.aws_eip.k8s_ip.id
}

# Create a DB subnet group for the RDS instance
resource "aws_db_subnet_group" "main" {
  name       = "main-subnet-group"
  subnet_ids = data.aws_subnet.private[*].id

  tags = merge(var.common_tags, {
    Name = "${var.common_tags["Project"]} Main Subnet-Group"
  })
}

# Create the RDS instance
resource "aws_db_instance" "main" {
  allocated_storage      = var.db_allocated_storage
  storage_type           = "gp2"
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  db_name                = "mydb"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [data.aws_security_group.rds_sg.id]
  skip_final_snapshot    = true

  tags = merge(var.common_tags, {
    Name = "${var.common_tags["Project"]} Main RDS DB"
  })
}
