output "db_instance_endpoint" {
  value = aws_db_instance.main.endpoint
}

output "db_instance_id" {
  value = aws_db_instance.main.id
}

output "k8s_instance_private_ip" {
  value = aws_instance.k8s_node.private_ip
}

output "k8s_public_ip" {
  value = var.k8s_public_ip
}

output "runner_instance_private_ip" {
  value = aws_instance.runner.private_ip
}

output "db_instance_address" {
  value = aws_db_instance.main.address
}

