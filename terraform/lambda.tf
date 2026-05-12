data "archive_file" "lambda_zip" {
  type = "zip"

  source_dir = "../lambda"

  output_path = "../lambda.zip"
}

resource "aws_lambda_function" "notification_lambda" {
  filename = data.archive_file.lambda_zip.output_path

  function_name = "notification-service"

  role = aws_iam_role.lambda_role.arn

  handler = "index.handler"

  runtime = "nodejs18.x"

  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.alerts.arn
    }
  }
}