import json
import boto3
import os
import time

from datetime import datetime


sqs = boto3.client('sqs')
queue_url = os.environ['QUEUE_URL']

def handler(event, context):
    execution_id = context.aws_request_id 
    for record in event['Records']:
        message_body = json.loads(record['body'])
        message_group_id = record['attributes']['MessageGroupId']
        
        message_body['consumer_execution_id'] = execution_id
        message_body['group_id'] = message_group_id
        message_body['timestamp'] = datetime.now().isoformat()

        process_message(message_body, message_group_id, context.aws_request_id )
        
        sqs.delete_message(
            QueueUrl=queue_url,
            ReceiptHandle=record['receiptHandle']
        )
    
    return {
        'statusCode': 200,
        'body': json.dumps('Messages processed successfully')
    }

def process_message(message_body, message_group_id, execution_id):
    # Implement your message processing logic here
    print(f"{message_body}")
    time.sleep(0.3)