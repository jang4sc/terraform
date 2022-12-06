variable "name" {
    description = "example"
    type = string
}

output "ifexample" {
    description = "example"
    value = "Hello, %{if var.name != ""}${var.name}%{else}(unnamed)%{endif}"
}