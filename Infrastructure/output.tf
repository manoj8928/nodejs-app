#retrieve the DNS name (URL) of the Application Load Balancer (ALB

output "alb_url" {
  description = "The DNS name (URL) of the Application Load Balancer."
  value       = aws_lb.this.dns_name
}

output "vpc_id" {
  value = module.demo_vpc.vpc_id
}

