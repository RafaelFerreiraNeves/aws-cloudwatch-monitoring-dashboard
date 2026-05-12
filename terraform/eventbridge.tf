resource "aws_cloudwatch_event_rule" "alarm_rule" {
  name = "alarm-state-change"

  event_pattern = jsonencode({
    source = [
      "aws.cloudwatch"
    ]
  })
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule = aws_cloudwatch_event_rule.alarm_rule.name

  arn = aws_lambda_function.notification_lambda.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id = "AllowExecutionFromEventBridge"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.notification_lambda.function_name

  principal = "events.amazonaws.com"

  source_arn = aws_cloudwatch_event_rule.alarm_rule.arn
}