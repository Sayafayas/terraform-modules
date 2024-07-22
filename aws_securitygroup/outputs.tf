output "k8s_sg_id" {
  value = aws_security_group.k8s_sg.id
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}

output "runner_sg_id" {
  value = aws_security_group.runner_sg.id
}
