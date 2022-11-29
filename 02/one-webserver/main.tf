provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "example" {
  ami                         = "ami-0fb653ca2d3203ac1"
  instance_type               = "t2.micro"
  user_data_replace_on_change = true
  vpc_security_group_ids      = [aws_security_group.instance.id]

  user_data = <<-EOF
            #!/bin/bash
            echo "Welcome To My Web Server" > index.html
            nohup busybox httpd -f -p 8080 &
            EOF

  tags = {
    Name = "terraform-example"
  }
}

resource "aws_security_group" "instance" {
  name = var.security_group_name

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "instance"
  }
}

variable "security_group_name" {
    description = "security group name"
    type = string
    default = "terraform-example-instance"
}

output "public_ip" {
    description = "ec2 instance public ip"
    value = aws_instance.example.public_ip
}
