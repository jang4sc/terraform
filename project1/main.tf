resource "aws_vpc" "bsc_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "bsc_public_subnet" {
  vpc_id                  = aws_vpc.bsc_vpc.id
  cidr_block              = "10.123.1.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "dev-public-subnet"
  }
}

resource "aws_internet_gateway" "bsc_igw" {
  vpc_id = aws_vpc.bsc_vpc.id

  tags = {
    Name = "dev-public-igw"
  }
}

resource "aws_route_table" "bsc_public_rt" {
  vpc_id = aws_vpc.bsc_vpc.id

  tags = {
    Name = "dev-public-rt"
  }
}

resource "aws_route" "bsc_default_route" {
  route_table_id         = aws_route_table.bsc_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.bsc_igw.id
}

resource "aws_route_table_association" "bsc_gw_subnet_assoc" {
  subnet_id      = aws_subnet.bsc_public_subnet.id
  route_table_id = aws_route_table.bsc_public_rt.id
}

resource "aws_security_group" "bsc_sg" {
  name        = "dev_sg"
  description = "dev security group"
  vpc_id      = aws_vpc.bsc_vpc.id

  ingress {
    description = "All allow incoming traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dev-sg"
  }
}

data "aws_ami" "dev-ubuntu-ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "bsc_auth" {
  key_name   = "bac-key"
  public_key = file("~/.ssh/bsckey.pub")
}

resource "aws_instance" "bsc-instance" {
  ami           = data.aws_ami.dev-ubuntu-ami.id
  instance_type = "t2.micro"

  key_name               = aws_key_pair.bsc_auth.id
  vpc_security_group_ids = [aws_security_group.bsc_sg.id]
  subnet_id              = aws_subnet.bsc_public_subnet.id

  user_data = file("user_data.tpl")
  user_data_replace_on_change = true

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "dev-instance"
  }
}