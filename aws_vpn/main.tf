# VPN Gateway
resource "aws_vpn_gateway" "main" {
  vpc_id = aws_vpc.worldofgames.id
  tags = merge(var.common_tags, {
    Name        = "${var.common_tags["Project"]} VPN Gateway",
    Environment = var.environment,
    Project     = var.project
  })
}

# Client VPN Endpoint
resource "aws_client_vpn_endpoint" "main" {
  description            = "My Client VPN Endpoint"
  server_certificate_arn = var.server_certificate_arn
  client_cidr_block      = var.client_cidr_block

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = var.client_certificate_arn
  }

  connection_log_options {
    enabled = false
  }

  dns_servers  = ["8.8.8.8"]
  split_tunnel = true

  tags = merge(var.common_tags, {
    Name        = "${var.common_tags["Project"]} Client VPN Endpoint",
    Environment = var.environment,
    Project     = var.project
  })
}

# Client VPN Network Association
resource "aws_client_vpn_network_association" "main" {
  client_vpn_endpoint_id = aws_client_vpn_endpoint.main.id
  subnet_id              = element(aws_subnet.public_subnets[*].id, 0) # Associate with a public subnet

  tags = merge(var.common_tags, {
    Name        = "${var.common_tags["Project"]} Client VPN Network Association",
    Environment = var.environment,
    Project     = var.project
  })
}

# Client VPN Authorization Rule
resource "aws_client_vpn_authorization_rule" "main" {
  client_vpn_endpoint_id = aws_client_vpn_endpoint.main.id
  target_network_cidr    = aws_vpc.worldofgames.cidr_block
  authorize_all_groups   = true

  tags = merge(var.common_tags, {
    Name        = "${var.common_tags["Project"]} Client VPN Authorization Rule",
    Environment = var.environment,
    Project     = var.project
  })
}
