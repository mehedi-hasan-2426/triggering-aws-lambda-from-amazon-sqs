output "sqs_queue_name" {
  description = "Name of the SQS queue."
  value       = aws_sqs_queue.order_processing.name
}

output "sqs_queue_url" {
  description = "URL of the SQS queue."
  value       = aws_sqs_queue.order_processing.url
}

output "lambda_function_name" {
  description = "Name of the Lambda function."
  value       = aws_lambda_function.process_orders.function_name
}

output "lambda_role_arn" {
  description = "IAM role ARN used by the Lambda function."
  value       = aws_iam_role.lambda_execution.arn
}

output "cloudwatch_log_group_name" {
  description = "CloudWatch log group used by the Lambda function."
  value       = aws_cloudwatch_log_group.lambda.name
}