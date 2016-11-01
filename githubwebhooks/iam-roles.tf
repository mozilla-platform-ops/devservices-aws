# The lambda receive role + policy allows:
# * Writing to CloudWatch
# * Writing to the firehose
# * Writing to SNS
resource "aws_iam_role" "lambda_github_webhooks_receive" {
    name = "lambda-github-webhooks-receive"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_github_webhooks_receive_policy" {
    name = "lambda-github-webhooks-receive"
    role = "${aws_iam_role.lambda_github_webhooks_receive.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "${aws_cloudwatch_log_group.lambda_receive.arn}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "firehose:PutRecord",
                "firehose:PutRecordBatch"
            ],
            "Resource": [
                "${aws_kinesis_firehose_delivery_stream.webhooks.arn}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "SNS:Publish"
            ],
            "Resource": [
                "${aws_sns_topic.webhooks_all.arn}",
                "${aws_sns_topic.webhooks_public.arn}"
            ]
        }
    ]
}
EOF
}

# The firehose policy allows:
# * Writing to CloudWatch
# * Writing to S3

resource "aws_iam_role" "kinesis_firehose_github_webhooks" {
    name = "kinesis-firehose-github-webhooks"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
            "Service": "firehose.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "firehose_github_webhooks" {
    name = "firehose-github-webhooks-kinesis-firehose"
    role = "${aws_iam_role.kinesis_firehose_github_webhooks.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:AbortMultipartUpload",
                "s3:GetBucketLocation",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:ListBucketMultipartUploads",
                "s3:PutObject"
            ],
            "Resource": [
                "${aws_s3_bucket.webhooks_bucket.arn}",
                "${aws_s3_bucket.webhooks_bucket.arn}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:PutLogEvents"
            ],
            "Resource": [
                "${aws_cloudwatch_log_group.kinesisfirehose_github_webhooks.arn}"
            ]
        }
    ]
}
EOF
}

# The Pulse role allows:
# * Writing to CloudWatch

resource "aws_iam_role" "lambda_github_webhooks_pulse" {
    name = "lambda-github-webhooks-pulse"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_github_webhooks_pulse" {
    name = "lambda-github-webhooks-pulse"
    role = "${aws_iam_role.lambda_github_webhooks_pulse.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "${aws_cloudwatch_log_group.lambda_pulse.arn}"
            ]
        }
    ]
}
EOF
}
