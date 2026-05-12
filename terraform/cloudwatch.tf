resource "aws_cloudwatch_log_group" "app_logs" {
  name = "/app/logs"
}

resource "aws_cloudwatch_log_metric_filter" "error_filter" {
  name = "error-filter"

  log_group_name = aws_cloudwatch_log_group.app_logs.name

  pattern = "ERROR"

  metric_transformation {
    name      = "ErrorCount"
    namespace = "AppMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "high_errors" {
  alarm_name = "high-error-alarm"

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 1

  metric_name = "ErrorCount"

  namespace = "AppMetrics"

  period = 60

  statistic = "Sum"

  threshold = 1

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]
}