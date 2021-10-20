resource "aws_sqs_queue" "sqs_standard_queues" {
  name                       = var.name
  visibility_timeout_seconds = var.visibility_timeout_seconds
}

resource "aws_sqs_queue_policy" "sqs_standard_queue_policies" {
  queue_url = aws_sqs_queue.sqs_standard_queues[var.name].id
  policy    = templatefile("${path.root}/conf/sqs-policy.json")
}

resource "aws_sqs_queue" "sqs_dlq_enabled_standard_queues" {
  name                       = var.name
  visibility_timeout_seconds = var.visibility_timeout_seconds
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.sqs_standard_queues["${terraform.workspace}-${var.dlq.name}"].arn
    maxReceiveCount     = var.max_recieve_count
  })
}

resource "aws_sqs_queue_policy" "sqs_dlq_enabled_standard_queue_policies" {
  queue_url = aws_sqs_queue.sqs_dlq_enabled_standard_queues[var.name].id
  policy    = file("${path.root}/conf/sqs-dlq-policy.json")
}
