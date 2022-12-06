variable "region" {
    description = "Default Region"
    default = "us-east-2"
}

variable "vpc_cidr" {
    description = "Default VPC CIDR"
    default = "190.160.0.0/16"
}

variable "seoul_tag" {
    description = "Default Seoul tags"
    type = map(string)
    default = {
      Name = "main"
      Location = "Seoul"
    }
}

variable "vpc_subnet_cidr" {
    description = "Default VPC and Sunbnet CIDR"
    type = list(string)
    default = ["190.160.1.0/24", "190.160.2.0/24", "190.160.3.0/24"]
}

#variable "asz" {
#    description = "Avaiable Zone"
#    type = list
#    default = ["us-east-2a", "us-east-2b", "us-east-2c"]
#}

data "aws_availability_zones" "azs" {}