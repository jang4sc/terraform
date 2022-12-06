data "aws_vpc" "default" {
    default = true
}

data "aws_subnets" "default" {
    filter {
        name = "vpc-id"
        values = [data.aws_vpc.default.id]
    }
}

# vpc
# subnets
#-----------------
# 초기 구성
# * security group
# * instance -> auto
# ASG
# * security group
# * lb
# * lb_listener
# * lb_target_group
# * lb_listener_rule
# * ASG

resource "aws_security_group" "instance" {
    name = var.instance_security_group_name

    ingress {
        from_port   = var.backend_server_port
        to_port     = var.backend_server_port
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

data "aws_ami" "ubuntu2004" {
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

resource "aws_launch_configuration" "default" {
    image_id = data.aws_ami.ubuntu2004.id
    instance_type = "t2.micro"
    security_groups = [aws_security_group.instance.id]
    user_data = file("user_data.tftpl")

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_security_group" "default" {
    name = var.alb_security_group_name

    # Allow inbound HTTP requests
    ingress {
        from_port   = var.frontend_server_port
        to_port     = var.backend_server_port
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

  # Allow all outbound requests
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_lb" "default" {
    name = var.alb_name

    load_balancer_type = "application"
    subnets = data.aws_subnets.default.ids
    security_groups = [aws_security_group.default.id]
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.default.arn
    port              = var.frontend_server_port
    protocol          = "HTTP"

    # By default, return a simple 404 page
    default_action {
        type = "fixed-response"

        fixed_response {
        content_type = "text/plain"
        message_body = "404: page not found"
        status_code  = 404
        }
    }
}

resource "aws_lb_target_group" "asg" {
    name = var.alb_name

    port     = var.backend_server_port
    protocol = "HTTP"
    vpc_id   = data.aws_vpc.default.id

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

resource "aws_lb_listener_rule" "asg" {
    listener_arn = aws_lb_listener.http.arn
    priority     = 100

    condition {
        path_pattern {
        values = ["*"]
        }
    }

    action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.asg.arn
    }
}

resource "aws_autoscaling_group" "default" {
    launch_configuration = aws_launch_configuration.default.name
    vpc_zone_identifier = data.aws_subnets.default.ids

    target_group_arns = [aws_lb_target_group.asg.arn]
    health_check_type = "ELB"

    min_size = 2
    max_size = 10

    tag {
        key                 = "Name"
        value               = "bsc_asg"
        propagate_at_launch = true
    }
}
