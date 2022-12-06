provider "aws" {
    region = "us-east-2"
}

module "bsc-module" {
    source = "./modules"

    instance_security_group_name = "instance-sg"
    backend_server_port = 8080
    frontend_server_port = 80
    alb_security_group_name = "alb-sg"
    alb_name = "alb"
}

output "alb_dns_name" {
  value       = module.bsc-module
  description = "The domain name of the load balancer"
}