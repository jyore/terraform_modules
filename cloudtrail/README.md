# cloudtrail

Stands up CloudTrail logging and creates backing resources for logging to S3 and recieving events
from an SQS queue.

This module creates all of the following resources & connects them together with appropriate IAM
policies

- CloudTrail trail
- S3 Bucket for logs
- SNS Topic for sending events
- SQS Queue to allow subscriptions to recieve the events from SNS

## Variables

> **trail_name**: The desired name for the Cloudtrail
> <br/>**s3_bucket_name**: The desired name for the S3 bucket
> <br/>**topic_name**: The desired name for the SNS Topic
> <br/>**queue_name**: The desired name for the SQS Queue
> <br/>**region**: The region to place the resources in
> <br/>**account_id**: The AWS Account ID where the resources are being placed (Needed for IAM policy)
> <br/>**s3_key_prefix** ( _Optional_ ): The S3 key prefix used for log file delivery
> <br/>**cloud_watch_logs_role_arn** ( _Optional_ ): The role for the CloudWatch Logs endpoint to assume
> <br/>**cloud_watch_logs_group_arn** ( _Optional_ ): A log group name to represent the log group the logs are delievered
> <br/>**enable_logging** ( _Default: true_ ): Enables logging for the trail
> <br/>**include_global_service_events** ( _Default: true_ ): Specify whether the trail is publishing events from global services such as IAM
> <br/>**is_multi_region_trail** ( _Default: false_ ): Specifies whether the trail is created in the current region or all regions
> <br/>**enable_log_file_validation** ( _Default: false_ ): Specifies whether log file integrity validation is enabled
> <br/>**kms_key_id** ( _Optional_ ): KMS key ARN to encrypt the logs delivered by CloudTrail


## Outputs

> **id**: The name of the trail
> <br/>**home_region**: The region in which the trail was created
> <br/>**arn**: The Amazon Resource Name of the trail
