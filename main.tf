provider "aws" {
  region = var.aws_region
}

locals {
  cloudwatch_log_group_name = "/aws/lambda/${var.lambda_function_name}"
}

data "archive_file" "lambda_package" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/${var.lambda_function_name}.zip"
}

resource "aws_sqs_queue" "order_processing" {
  name                       = var.queue_name
  visibility_timeout_seconds = 60
  delay_seconds              = 0
  receive_wait_time_seconds  = 20
  message_retention_seconds  = 345600
  max_message_size           = 262144

  tags = var.tags
}

resource "aws_iam_role" "lambda_execution" {
  name = var.lambda_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "lambda_sqs_execution" {
  role       = aws_iam_role.lambda_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = local.cloudwatch_log_group_name
  retention_in_days = var.log_retention_in_days

  tags = var.tags
}

resource "aws_lambda_function" "process_orders" {
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_execution.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = var.lambda_runtime
  filename         = data.archive_file.lambda_package.output_path
  source_code_hash = data.archive_file.lambda_package.output_base64sha256
  timeout          = 60

  depends_on = [
    aws_cloudwatch_log_group.lambda,
    aws_iam_role_policy_attachment.lambda_sqs_execution
  ]

  tags = var.tags
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.order_processing.arn
  function_name    = aws_lambda_function.process_orders.arn
  enabled          = true
  batch_size       = 10
}