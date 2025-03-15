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