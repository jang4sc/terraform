####################################
# 1. provider
# 2. S3 mybucket 생성
####################################

####################################
# 1. provider
####################################
provider "aws" {
  region = "us-east-2"
}

####################################
# 2. S3 mybucket 생성
####################################
resource "aws_s3_bucket" "mytfstate" {
  bucket = "mybsc-4444"
  force_destroy = true

  tags = {
    Name        = "mytfstate"
  }
}
