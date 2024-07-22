output "vpc_id" {
  value = aws_vpc.worldofgames.id
}

output "public_subnet_cidrs" {
  value = aws_subnet.public_subnets[*].cidr_block
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "private_subnet_cidrs" {
  value = aws_subnet.private_subnets[*].cidr_block
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}

output "nat_gateway_public_ip" {
  value = aws_eip.nat_gateway_ip[*].public_ip
}

output "k8s_public_ip" {
  value = aws_eip.k8s_ip.public_ip
}

output "k8s_allocation_id" {
  value = aws_eip.k8s_ip.allocation_id
}
