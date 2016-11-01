GitHub Web Hooks Processing
===========================

This directory contains a Terraform environment defining the GitHub
web hooks ingestion and processing mechanism.

From a high-level:

* An API Gateway processes HTTP requests from GitHub and hands them
  off to a Lambda function to process them.
* The Lambda function writes events to a Kinesis Firehose and SNS
  topics. One topic contains all events. Another contains only the
  *public* events.
* The Kinesis Firehose writes events to S3, where they are retained
  forever so we have historical data.
* A Lambda function listens for events on the *public* topic and
  republishes them to Pulse, Mozilla's AMQP exchange.

Supporting all of this are:

* CloudWatch log groups so everything can log activity.
* IAM roles and policies to allow everything to talk to each other.

The Lambda functions are defined in the version-control-tools
repository. That repository has its own code for uploading a new
version of the execution environment and triggering a refresh of the
Lambda environment.
