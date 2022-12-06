variable "db_name" {
  description = "The name to use for the database"
  type        = string
  default     = "example_database_stage"
}

# default 값은 지정되지 않았다. TF_VAR_db_username 변수로 설정한다.
variable "db_username" {
  description = "The username for the database"
  type        = string
  sensitive   = true
}

# default 값은 지정되지 않는다. TF_VAR_db_password 변수로 설정한다.
variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}