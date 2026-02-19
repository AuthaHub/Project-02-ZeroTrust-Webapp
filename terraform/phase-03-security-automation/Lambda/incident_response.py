import json
import os
import boto3

sns_client = boto3.client('sns')
ec2_client = boto3.client('ec2')

SNS_TOPIC_ARN = os.environ['SNS_TOPIC_ARN']
ENVIRONMENT = os.environ['ENVIRONMENT']

def lambda_handler(event, context):
    print(f"Received event: {json.dumps(event)}")
    
    detail = event.get('detail', {})
    instance_id = detail.get('instance-id', 'unknown')
    state = detail.get('state', 'unknown')
    
    message = f"""
SECURITY ALERT - Zero Trust Webapp ({ENVIRONMENT})

EC2 Instance State Change Detected:
- Instance ID: {instance_id}
- New State: {state}
- Time: {event.get('time', 'unknown')}

Automated incident response triggered.
Please investigate if this change was unexpected.
    """
    
    sns_client.publish(
        TopicArn=SNS_TOPIC_ARN,
        Subject=f"[{ENVIRONMENT.upper()}] EC2 State Change: {instance_id} -> {state}",
        Message=message
    )
    
    print(f"Alert sent for instance {instance_id} state change to {state}")
    
    return {
        'statusCode': 200,
        'body': json.dumps('Incident response completed')
    }