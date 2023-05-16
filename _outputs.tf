

output "loadbalancer_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.web_lb.dns_name
}

# RDS
output "rds_master_password" {
  description = "RDS master password"
  value       = local.random_password.rds_password.result
  sensitive   = true
}