resource "aws_cloudwatch_event_rule" "every_minute_produce_message" {
  name                = "every_minute_produce_message"
  description         = "Schedule to produce message every minute"
  schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "lambda_producer_target" {
  rule      = aws_cloudwatch_event_rule.every_minute_produce_message.name
  target_id = aws_lambda_function.produce_message.function_name
  arn       = aws_lambda_function.produce_message.arn
}