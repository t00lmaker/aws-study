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
    execution_id = context.aws_request_id 
    for j in range(5):
        messages = []
        for i in range(10):
            message_group_id = random.choice(list(message_groups.keys()))
            message_body = {
                'timestamp': datetime.now().isoformat(),
                'execution_id': execution_id, 
                'group_id': message_group_id,
                'j': j+1,
                'i': i+1
            }

            
            print(f'Sending message to group {message_group_id}: {message_body}')

            messages.append({
                'Id': f"{execution_id}{str(j)}{str(i)}",
                'MessageBody': json.dumps(message_body),
                'MessageGroupId': message_group_id
            })

        response = sqs.send_message_batch(
            QueueUrl=queue_url,
            Entries=messages
        )

    return {
        'statusCode': 200,
        'body': json.dumps(response)
    }