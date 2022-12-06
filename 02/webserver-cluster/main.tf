provider "aws" {
  region = "us-east-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

# 1. AWS Launch Configuration
# * Web Server
# * [v] security group
resource "aws_launch_configuration" "example" {
  name          = "example_instance"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  security_groups = [aws_security_group.default.id]

  user_data = <<-EOF
    #!/bin/bash
    echo "My Web Server" > index.html
    nohup busybox httpd -f -p 80 &
  EOF

  lifecycle {
    create_before_destroy = true
  }
}

# 2. Autoscaling Group 
resource "aws_autoscaling_group" "example" {
  name                      = var.asg_name
  max_size                  = 10
  min_size                  = 2
  health_check_type         = "ELB"

  launch_configuration      = aws_launch_configuration.example.name
  vpc_zone_identifier       = data.aws_subnets.default.ids
}    

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_vpc" "default" {
  default = true
}

# 3. Security Group 
resource "aws_security_group" "default" {
  name        = var.sg_name
  description = "Default Security Group"

  ingress {
    description      = "Inbount 80/tcp"
    from_port        = var.http_port
    to_port          = var.http_port
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "test1"
  }
}

# 4. ELB
# * 4-1) lb
# * 4-2) listener
# * 4-3) listener rule
# * 4-4) target group 
resource "aws_lb" "example" {
  name               = var.lb_name
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = data.aws_subnets.default.ids

  tags = {
    Name = "test1"
  }
}

resource "aws_security_group" "alb" {
  name        = var.lb_sg_name
  description = "Allow HTTP inbound traffic"

  ingress {
    description      = "HTTP from VPC"
    from_port        = var.http_port
    to_port          = var.http_port
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "test1"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404 not found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "example" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example.arn
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }
}

resource "aws_lb_target_group" "example" {
  name        = "example-tg"
  port        = var.http_port
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}