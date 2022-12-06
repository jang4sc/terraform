variable "instance_security_group_name" {
    description = "EC2 Instance Security Group Name"
    type = string
}

variable "backend_server_port" {
    description = "Backend Web Server Port Number"
    type = number
}

variable "alb_security_group_name" {
    description = "ALB Security Group Name"
    type = string
}

variable "frontend_server_port" {
    description = "Frontend Web Server Port Number"
    type = number
}

variable "alb_name" {
    description = "Application Load Balancer"
    type = string
}