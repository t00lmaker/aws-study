data "archive_file" "lambda_producer_zip" {
  type        = "zip"
  source_dir  = local.producer_code_path
  output_path = local.producer_zip_path
}

resource "aws_lambda_function" "produce_message" {
  filename         = data.archive_file.lambda_producer_zip.output_path
  function_name    = "produce_message"
  role             = aws_iam_role.lambda_producer_role.arn
  handler          = "index.handler"
  runtime          = "python3.9"
  source_code_hash = data.archive_file.lambda_producer_zip.output_base64sha256

  environment {
    variables = {
      QUEUE_URL = aws_sqs_queue.message_queue.url
    }
  }

  depends_on = [ data.archive_file.lambda_producer_zip ]
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.produce_message.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_minute_produce_message.arn
}

data "archive_file" "lambda_consumer_zip" {
  type        = "zip"
  source_dir  = local.consumer_code_path
  output_path = local.consumer_zip_path
}


resource "aws_lambda_function" "consume_message" {
  filename         = data.archive_file.lambda_consumer_zip.output_path
  function_name    = "consume_message"
  role             = aws_iam_role.lambda_consumer_role.arn
  handler          = "consumer.handler"
  runtime          = "python3.9"
  source_code_hash = data.archive_file.lambda_consumer_zip.output_base64sha256

  environment {
    variables = {
      QUEUE_URL = aws_sqs_queue.message_queue.url
    }
  }

  depends_on = [ data.archive_file.lambda_consumer_zip ]
}

resource "aws_lambda_event_source_mapping" "sqs_event_source" {
  event_source_arn  = aws_sqs_queue.message_queue.arn
  function_name     = aws_lambda_function.consume_message.arn
  batch_size        = 10
  enabled           = true
}

resource "aws_lambda_permission" "allow_sqs" {
  statement_id  = "AllowExecutionFromSQS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.consume_message.function_name
  principal     = "sqs.amazonaws.com"
  source_arn    = aws_sqs_queue.message_queue.arn
}