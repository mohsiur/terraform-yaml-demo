## SQS
module "sqs" {
  source      = "../modules/sqs"
  config_file = var.config_file
}
