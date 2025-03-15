import json
import boto3
import os
import random
from datetime import datetime

sqs = boto3.client('sqs')
queue_url = os.environ['QUEUE_URL']

message_groups = {
    'group1': 'Group 1',
    'group2': 'Group 2',
    'group3': 'Group 3'
}

def handler(event, context):
    message_body = {
        'timestamp': datetime.now().isoformat(),
        'message': 'Hello from Lambda!'
    }

    message_group_id = random.choice(list(message_groups.keys()))

    response = sqs.send_message(
        QueueUrl=queue_url,
        MessageBody=json.dumps(message_body),
        MessageGroupId=message_group_id
    )
    return {
        'statusCode': 200,
        'body': json.dumps(response)
    }