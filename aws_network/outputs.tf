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

output "k8s_ip" {
  value = aws_eip.k8s_ip.public_ip
}
