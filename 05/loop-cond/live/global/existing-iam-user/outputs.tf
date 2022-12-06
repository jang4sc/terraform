output "user_arn" {
    description = "All users arn"
    value = values(aws_iam_user.createuser)[*].arn
}