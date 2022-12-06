provider "aws" {
  region = "us-east-2"
  secret_key = "AKIA54LRERVSMI3SMWUN"
  access_key = "ZKSE/JCb0FA3o/z7gGz72DppCBNxmHQ97bnVpxQB"
}

terraform {
  backend "s3" {
    encrypt = false
    bucket = "bucket-1974-0710"
    dynamodb_table = "tf-state-lock-dynamo"
    key = "global/s3/terraform.tfstate"
    region = "us-east-2"
  }
}

resource "aws_vpc" "tf_test" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "tf_test"
  }
}

resource "aws_subnet" "Subnet-tf-public" {
  vpc_id     = aws_vpc.tf_test.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "Subnet-tf-public"
  }
}

resource "aws_subnet" "Subnet-tf-private" {
  vpc_id     = aws_vpc.tf_test.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "Subnet-tf-private"
  }
}
