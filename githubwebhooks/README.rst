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

Configuring Secret Variables
============================

The ``github-webhooks-pulse`` Lambda function has user credentials for Pulse
defined in environment variables. These credentials can't be checked into
this repository.

When running ``terraform``, you may be prompted for these credentials.

To avoid being prompted, you can define these variables in an offline
file. The content of that file would look something like::

    pulse_user = "<username>"
    pulse_password = "<password>"

.. hint::

   If you view the Lambda function in the AWS web console, the username and
   password will be printed in plain text in the ``Environment variables``
   section of the ``Code`` tab.

Then, pass ``-var-file`` to ``terraform`` to tell it to load that variables
file. e.g.

   $ terraform plan -var-file ~/.tf_githubwebhooks.tfvars

If the credentials are defined properly and you haven't made any
Terraform changes, that above command should not prompt you for credentials
and should say there are no changes to be made.
