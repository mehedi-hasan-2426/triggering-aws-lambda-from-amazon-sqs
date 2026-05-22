# Triggering AWS Lambda from Amazon SQS

This project is an AWS exercise I did to practice asynchronous processing with Amazon SQS and AWS Lambda using Terraform.

The setup creates:

- an SQS standard queue named `order-processing-queue`
- a Lambda function named `process-orders-function`
- an IAM role with the permissions needed for Lambda to poll SQS
- an event source mapping between the queue and the function
- a CloudWatch log group for checking the function output

## What this exercise covers

The goal was to build a simple message-driven flow where:

1. a message is sent to SQS
2. Lambda reads the message from the queue
3. valid JSON is processed and logged
4. malformed JSON is handled without crashing the function

## Project files

- `versions.tf` Terraform and provider requirements
- `variables.tf` configurable values
- `main.tf` AWS resources
- `outputs.tf` useful outputs after deployment
- `lambda_function.py` Lambda handler packaged by Terraform

## Requirements

- Terraform 1.5+
- an AWS account or temporary lab account
- AWS region set to `us-east-1`

I used lab credentials locally, but those should never be committed to GitHub.

## How to run

```powershell
cd triggering-aws-lambda-from-amazon-sqs
terraform init
terraform apply
```

## Test messages

Example valid message:

```json
{ "order_id": 123, "customer_name": "Selena", "amount": 59.99 }
```

Example malformed message:

```json
{ order_id: 124, customer_name: Bob }
```

## Checking the result

After deployment, send messages to the queue and check the Lambda logs in CloudWatch.

- A valid message should appear as `Processed message`
- An invalid JSON message should appear as an error message

## Notes

- The queue is configured with a 60 second visibility timeout and 20 second long polling.
- The default Lambda runtime in this repo is `python3.13`. If your account supports a newer runtime, you can update `lambda_runtime` in `variables.tf`.