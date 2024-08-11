output "vpc_id" {
  value = aws_vpc.worldofgames.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}

output "public_subnet_cidrs" {
  value = var.public_subnet_cidrs
}

output "private_subnet_cidrs" {
  value = var.private_subnet_cidrs
}

output "nat_gateway_ids" {
  value = aws_nat_gateway.nat[*].id
}

output "nat_gateway_ips" {
  value = aws_eip.nat_gateway_ip[*].public_ip
}

output "client_vpn_endpoint_id" {
  value = aws_client_vpn_endpoint.main.id
}

output "client_vpn_network_association_id" {
  value = aws_client_vpn_network_association.main.id
}

output "client_vpn_authorization_rule_id" {
  value = aws_client_vpn_authorization_rule.main.id
}
