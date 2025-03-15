resource "aws_sqs_queue" "message_queue" {
  name                        = "queue-messages.fifo"
  fifo_queue                  = true
  content_based_deduplication = true

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = 5
  })
}

resource "aws_sqs_queue" "message_dlq" {
  name = "queue-messages-dlq.fifo"
  fifo_queue                  = true
}