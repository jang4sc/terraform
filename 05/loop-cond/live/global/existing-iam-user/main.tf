provider "aws" {
  region = "us-east-2"
}

resource "aws_iam_user" "createuser" {
  # Make sure to update this to your own user name!
  for_each = toset(var.user_names)
  name = each.value
}

