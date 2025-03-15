import json
import boto3
import os

sqs = boto3.client('sqs')
queue_url = os.environ['QUEUE_URL']

def handler(event, context):
    for record in event['Records']:
        message_body = json.loads(record['body'])
        message_group_id = record['attributes']['MessageGroupId']
        
        # Process the message based on the MessageGroupId
        process_message(message_body, message_group_id)
        
        # Delete the message from the queue after processing
        sqs.delete_message(
            QueueUrl=queue_url,
            ReceiptHandle=record['receiptHandle']
        )
    
    return {
        'statusCode': 200,
        'body': json.dumps('Messages processed successfully')
    }

def process_message(message_body, message_group_id):
    # Implement your message processing logic here
    print(f"Processing message from group {message_group_id}: {message_body}")