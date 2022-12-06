variable "user_names" {
    description = "IAM User list"
    type = list(string)
    default = ["red", "blue", "green"]
}
