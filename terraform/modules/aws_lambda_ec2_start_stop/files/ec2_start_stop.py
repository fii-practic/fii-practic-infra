#!/usr/bin/env python3
import boto3

ec2_client = boto3.client('ec2')


def which_instances_stop():
    response = ec2_client.describe_instances(
        Filters=[
            {
                'Name': 'tag:cron',
                'Values': [
                    'on',
                ]
            },
        ],
    )

    instance_ids = []

    for r in response['Reservations']:
        for i in r['Instances']:
            instance_ids.append(i['InstanceId'])
    return instance_ids


def which_instances_start():
    response = ec2_client.describe_instances(
        Filters=[
            {
                'Name': 'tag:switch',
                'Values': [
                    'on',
                ]
            },
        ],
    )

    instance_ids = []

    for r in response['Reservations']:
        for i in r['Instances']:
            instance_ids.append(i['InstanceId'])
    return instance_ids


def stop_instances():
    response = ec2_client.stop_instances(
        InstanceIds=which_instances_stop(),
    )
    return response


def start_instances():
    response = ec2_client.start_instances(
        InstanceIds=which_instances_start(),
    )
    return response


def lambda_handler(event, context):

    print('DEBUG the EVENT:{}'.format(event))

    if event.get('command') == 'stop':
        print(stop_instances())
    elif event.get('command') == 'start':
        print(start_instances())
        #print('This is the EVENT:{}'.format(event))
    else:
        print("WTF")


if __name__ == '__main__':
    event = {}
