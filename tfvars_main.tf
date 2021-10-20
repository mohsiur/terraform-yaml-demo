module "sqs_tfvars_standard_queue" {
  source                     = "modules/sqs_tfvars"
  name                       = var.sqs_name
  visibility_timeout_seconds = 10
  access_policy              = "basic"
  env                        = terraform.workspace
}

module "sqs_tfvars_standard_queue_2" {
  source                     = "modules/sqs_tfvars"
  name                       = var.sqs_name
  visibility_timeout_seconds = 10
  access_policy              = "basic"
  env                        = terraform.workspace
}

# Without using complex maps and lists, we have to repeat this multiple times
