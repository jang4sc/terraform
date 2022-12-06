# 기본값이 없다. 유일한 값이 들어가야 해서 일부러 입력하도록 하기 위함이다.
variable "bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique."
  type        = string
}

# 기본값이 없다. 유일한 값이 들어가야 해서 일부러 입력하도록 하기 위함이다.
variable "table_name" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
}