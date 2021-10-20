## Manage standard queues and their access policies
resource "aws_sqs_queue" "sqs_standard_queues" {
  for_each = {
    for queue in local.sqs_standard_queues : queue.name => queue
    if queue.dlq == null
  }

  name                       = each.value.name
  visibility_timeout_seconds = each.value.visibility_timeout_seconds
}

resource "aws_sqs_queue_policy" "sqs_standard_queue_policies" {
  for_each = {
    for queue in local.sqs_standard_queues : queue.name => queue
    if queue.dlq == null
  }

  queue_url = aws_sqs_queue.sqs_standard_queues[each.value.name].id
  policy    = file("${path.root}/conf/sqs-policy.json")
}

## Manage standard queues with DLQ enabled and their access poicies
resource "aws_sqs_queue" "sqs_dlq_enabled_standard_queues" {
  for_each = {
    for queue in local.sqs_standard_queues : queue.name => queue
    if queue.dlq != null
  }

  name                       = each.value.name
  visibility_timeout_seconds = each.value.visibility_timeout_seconds
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.sqs_standard_queues["${terraform.workspace}-${each.value.dlq.name}"].arn
    maxReceiveCount     = each.value.dlq.max_recieve_count
  })
}

resource "aws_sqs_queue_policy" "sqs_dlq_enabled_standard_queue_policies" {
  for_each = {
    for queue in local.sqs_standard_queues : queue.name => queue
    if queue.dlq != null
  }

  queue_url = aws_sqs_queue.sqs_dlq_enabled_standard_queues[each.value.name].id
  policy    = file("${path.root}/conf/sqs-dlq-policy.json")
}
