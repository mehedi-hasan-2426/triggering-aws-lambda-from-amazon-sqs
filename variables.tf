variable "aws_region" {
  description = "AWS region for the lab resources."
  type        = string
  default     = "us-east-1"
}

variable "queue_name" {
  description = "Name of the SQS queue that stores order messages."
  type        = string
  default     = "order-processing-queue"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function that processes SQS messages."
  type        = string
  default     = "process-orders-function"
}

variable "lambda_role_name" {
  description = "Name of the IAM role assumed by the Lambda function."
  type        = string
  default     = "AWSLambdaSQSQueueExecutionRole"
}

variable "lambda_runtime" {
  description = "Python runtime for the Lambda function. Update if your lab account exposes a newer supported runtime."
  type        = string
  default     = "python3.13"
}

variable "log_retention_in_days" {
  description = "Retention period for Lambda CloudWatch logs."
  type        = number
  default     = 14
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default = {
    Project     = "triggering-aws-lambda-from-amazon-sqs"
    Environment = "lab"
  }
}