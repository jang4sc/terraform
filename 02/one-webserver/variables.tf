variable "security_group_name" {
    description = "security group name"
    type = string
    default = "terraform-example-instance"
}

variable "server_port" {
    description = "web server port"
    type = number
    default = 8080
}
