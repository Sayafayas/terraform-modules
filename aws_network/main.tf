# Data source to fetch the list of available availability zones
data "aws_availability_zones" "available" {}

# Create a VPC with the specified CIDR block, DNS support, and DNS hostnames enabled
resource "aws_vpc" "worldofgames" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.common_tags, {
    Name        = "${var.common_tags["Project"]} Main VPC",
    Environment = var.environment,
    Project     = var.project
  })
}

# Create public subnets within the VPC
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.worldofgames.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]

  tags = merge(var.common_tags, {
    Name        = "${var.common_tags["Project"]} Public Subnet-${count.index + 1}",
    Environment = var.environment,
    Project     = var.project
  })
}

# Create private subnets within the VPC
resource "aws_subnet" "private_subnets" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.worldofgames.id
  cidr_block              = element(var.private_subnet_cidrs, count.index)
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = merge(var.common_tags, {
    Name        = "${var.common_tags["Project"]} Private Subnet-${count.index + 1}",
    Environment = var.environment,
    Project     = var.project
  })
}

# Create an Internet Gateway and attach it to the VPC
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.worldofgames.id
  tags = merge(var.common_tags, {
    Name        = "${var.common_tags["Project"]} Main Internet GW",
    Environment = var.environment,
    Project     = var.project
  })
}

# Create a NAT Gateway in the first public subnet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_gateway_ip.id
  subnet_id     = element(aws_subnet.public_subnets[*].id, 0) # Use the first public subnet
  tags = merge(var.common_tags, {
    Name        = "${var.common_tags["Project"]} NAT Gateway",
    Environment = var.environment,
    Project     = var.project
  })
}

# Allocate an Elastic IP for the NAT Gateway
resource "aws_eip" "nat_gateway_ip" {
  tags = merge(var.common_tags, {
    Name        = "${var.common_tags["Project"]} NAT EIP",
    Environment = var.environment,
    Project     = var.project
  })
}

# Allocate an Elastic IP for the k3s node
resource "aws_eip" "k8s_ip" {
  tags = merge(var.common_tags, {
    Name        = "${var.common_tags["Project"]} k8s EIP",
    Environment = var.environment,
    Project     = var.project
  })
}

# Create a public route table and associate it with the Internet Gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.worldofgames.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.common_tags, {
    Name        = "${var.common_tags["Project"]} Public Route Table",
    Environment = var.environment,
    Project     = var.project
  })
}

# Associate the public route table with the public subnets
resource "aws_route_table_association" "public_routes" {
  count          = length(aws_subnet.public_subnets[*].id)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

# Create a private route table and associate it with the NAT Gateway
resource "aws_route_table" "private" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.worldofgames.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id # Use single NAT Gateway
  }

  tags = merge(var.common_tags, {
    Name        = "${var.common_tags["Project"]} Private Route Table-${count.index + 1}",
    Environment = var.environment,
    Project     = var.project
  })
}

# Associate the private route table with the private subnets
resource "aws_route_table_association" "private_routes" {
  count          = length(aws_subnet.private_subnets[*].id)
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_route_table.private[count.index].id
}
