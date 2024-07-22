resource "aws_instance" "runner" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = var.runner_instance_type
  subnet_id                   = element(data.terraform_remote_state.network.outputs.private_subnet_ids, 0)
  vpc_security_group_ids      = [data.terraform_remote_state.security.outputs.runner_sg_id]
  key_name                    = var.key_pair_name
  associate_public_ip_address = false

  tags = merge(var.common_tags, { Name = "${var.common_tags["Project"]} Runner" })
}

resource "aws_instance" "k8s_node" {
  ami             = data.aws_ami.latest_amazon_linux.id
  instance_type   = var.instance_type
  subnet_id       = element(data.terraform_remote_state.network.outputs.public_subnet_ids, 0)
  security_groups = [data.terraform_remote_state.security.outputs.k8s_sg_id]
  key_name        = var.key_pair_name

  tags = merge(var.common_tags, { Name = "${var.common_tags["Project"]} k8s-Node" })

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      ami,
      instance_type,
      security_groups,
    ]
  }
}

resource "aws_eip_association" "k8s_eip_assoc" {
  instance_id   = aws_instance.k8s_node.id
  allocation_id = data.terraform_remote_state.network.outputs.k8s_allocation_id
}

resource "aws_db_subnet_group" "main" {
  name       = "main-subnet-group"
  subnet_ids = tolist(data.terraform_remote_state.network.outputs.private_subnet_ids)

  tags = merge(var.common_tags, { Name = "${var.common_tags["Project"]} Main Subnet-Group" })
}

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
  vpc_security_group_ids = [data.terraform_remote_state.security.outputs.rds_sg_id]
  skip_final_snapshot    = true

  tags = merge(var.common_tags, { Name = "${var.common_tags["Project"]} Main RDS DB" })
}
