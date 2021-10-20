# This file decodes the yaml file and makes it into a terraform map than can then be used with for_each statements
locals {
  sqs_queues = yamldecode(file("${path.root}/conf/sqs/${var.config_file}"))["queues"] # this converts all the queues into a list of maps 
  # i.e the list looks as follows
  #[
  #  {
  #    "access_policy" = "basic"
  #    "env" = [
  #      "production",
  #      "dev",
  #    ]
  #    "name" = "example-queue-dlq"
  #    "type" = "standard"
  #  },
  #  ...
  #]
  # The following statement flattens the list of maps into a list of maps that is flattened and easier for us to use
  sqs_standard_queues = flatten([for queue in local.sqs_queues :
    {
      "name"                       = "${terraform.workspace}-${queue.name}"
      "type"                       = queue.type
      "access_policy"              = queue.access_policy
      "dlq"                        = lookup(queue, "dlq", null)
      "visibility_timeout_seconds" = lookup(queue, "visibility_timeout_seconds", 30)
    }
    if contains(queue.env, terraform.workspace)
  ])
  # i.e this is what sqs_standard_queues looks like
  # [
  #   {
  #     "access_policy" = "basic"
  #     "dlq" = null
  #     "name" = "production-example-queue-dlq"
  #     "type" = "standard"
  #   },
  #   {
  #     "access_policy" = "basic"
  #     "dlq" = {
  #       "max_recieve_count" = 1
  #       "name" = "production-example-queue-dlq"
  #     }
  #     "name" = "production-example-queue"
  #     "type" = "standard"
  #     "visibility_timeout_seconds" = 10
  #   },
}
