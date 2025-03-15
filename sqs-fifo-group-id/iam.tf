resource "aws_iam_role" "lambda_producer_role" {
  name = "lambda-producer-sqs-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "producer_policy" {
  name   = "produce-sqs-policy"
  role   = aws_iam_role.lambda_producer_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sqs:SendMessage"
        ]
        Effect   = "Allow"
        Resource = aws_sqs_queue.fifo_queue.arn
      }
    ]
  })
}