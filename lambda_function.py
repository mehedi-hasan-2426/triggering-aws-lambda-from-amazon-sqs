import json


def lambda_handler(event, context):
    for record in event["Records"]:
        try:
            message = json.loads(record["body"])
            order_id = message.get("order_id")
            customer_name = message.get("customer_name")
            amount = message.get("amount")

            summary = f"Order #{order_id} for {customer_name} - Amount: ${amount}"
            print("Processed message:", summary)

        except json.JSONDecodeError:
            print("Error: Received malformed JSON message:", record["body"])

        except Exception as error:
            print("Unexpected error:", str(error))