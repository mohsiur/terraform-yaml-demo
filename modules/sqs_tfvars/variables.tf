variable "name" {
  description = "Name of the queue"
}

variable "visibility_timeout_seconds" {
  description = "(optional) visibility_timeout_seconds"
}

variable "access_policy" {
  description = "access_policy"
}

variable "account_id" {
  description = "account_id"
}

variable "max_recieve_count" {
    type = string
    description = "max_recieve_count"
}
