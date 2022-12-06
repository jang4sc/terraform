variable "asg_name" {
    description = "ASG name"
    type = string
    default = "example_asg"
}

variable "sg_name" {
    description = "SG name"
    type = string
    default = "default_security_group"
}

variable "lb_name" {
    description = "LB name"
    type = string
    default = "example-elb"
}

variable "lb_sg_name" {
    description = "SG name for LB"
    type = string
    default = "default_alb"
}

variable "lb_tg_name" {
    description = "TG name for LB"
    type = string
    default = "example-tg"
}

variable "http_port" {
    description = "HTTP Server port number"
    type = number
    default = 80
}