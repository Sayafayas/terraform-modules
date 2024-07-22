
data "aws_availability_zones" "available" {}

resource "aws_vpc" "worldofgames" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.common_tags, { Name = "${var.common_tags["Project"]} Main VPC" })
}

resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.worldofgames.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = merge(var.common_tags, { Name = "${var.common_tags["Project"]} Public Subnet-${count.index + 1}" })
}

resource "aws_subnet" "private_subnets" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.worldofgames.id
  cidr_block              = element(var.private_subnet_cidrs, count.index)
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[count.index]


  tags = merge(var.common_tags, { Name = "${var.common_tags["Project"]} Private Subnet-${count.index + 1}" })
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.worldofgames.id
  tags   = merge(var.common_tags, { Name = "${var.common_tags["Project"]} Main Internet GW" })
}

resource "aws_nat_gateway" "nat" {
  count         = length(var.private_subnet_cidrs)
  allocation_id = element(aws_eip.nat_gateway_ip[*].id, count.index)
  subnet_id     = element(aws_subnet.public_subnets[*].id, count.index)
  tags          = merge(var.common_tags, { Name = "${var.common_tags["Project"]} NAT Gateway-${count.index + 1}" })
}

resource "aws_eip" "nat_gateway_ip" {
  count = length(var.private_subnet_cidrs)
  tags  = merge(var.common_tags, { Name = "${var.common_tags["Project"]} NAT EIP" })
}

resource "aws_eip" "k8s_ip" {
  tags = merge(var.common_tags, { Name = "${var.common_tags["Project"]} k8s EIP" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.worldofgames.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.common_tags, { Name = "${var.common_tags["Project"]} Public Route Table" })
}

resource "aws_route_table_association" "public_routes" {
  count          = length(aws_subnet.public_subnets[*].id)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.worldofgames.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat[*].id, count.index)
  }

  tags = merge(var.common_tags, { Name = "${var.common_tags["Project"]} Private Route Table-${count.index + 1}" })
}

resource "aws_route_table_association" "private_routes" {
  count          = length(aws_subnet.private_subnets[*].id)
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_route_table.private[count.index].id
}
