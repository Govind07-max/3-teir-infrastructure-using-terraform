output "alb_security_group_id" {
  description = "ALB Security Group ID"
  value       = module.security.alb_sg_id
}

output "app_security_group_id" {
  description = "App Security Group ID"
  value       = module.security.app_sg_id
}

output "db_security_group_id" {
  description = "DB Security Group ID"
  value       = module.security.db_sg_id
}

output "alb_dns_name" {
  description = "Public URL of Application Load Balancer"
  value       = module.alb.alb_dns_name
}

