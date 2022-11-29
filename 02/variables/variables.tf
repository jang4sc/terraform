provider "aws" {
    region = "us-east-2"
}

# number_example=42
variable "number_example" {
  description = "Variable Definition Example"
  type = number
  default = 42
}

variable "list_example" {
  description = "Variable Definition Example"
  type = list
  default = ["a", "b", "c"]
}

variable "list_number_example" {
  type = list(number)
  default = [1, 2, 3]
}

variable "map_example" {
    type = map(string)
    default = {
        k1 = "v1"
        k2 = "v2"
        k3 = "v3"
    }
}
