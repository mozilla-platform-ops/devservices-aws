data "aws_iam_policy_document" "lambda_assume_role" {
    statement = {
        effect = "Allow"
        actions = [
            "sts:AssumeRole",
        ]
        principals {
            type = "Service"
            identifiers = [
                "lambda.amazonaws.com",
            ]
        }
    }
}

resource "aws_iam_role" "lambda_github_webhooks_receive" {
    name = "lambda-github-webhooks-receive"
    assume_role_policy = "${data.aws_iam_policy_document.lambda_assume_role.json}"
}

data "aws_iam_policy_document" "lambda_github_webhooks_receive" {
    # Allow writing CloudWatch logs.
    statement = {
        effect = "Allow"
        actions = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
        ]
        resources = [
            "${aws_cloudwatch_log_group.lambda_receive.arn}",
        ]
    }

    # Allow writing to Kinesis Firehose.
    statement = {
        effect = "Allow"
        actions = [
            "firehose:PutRecord",
            "firehose:PutRecordBatch"
        ]
        resources = [
            "${aws_kinesis_firehose_delivery_stream.webhooks.arn}",
        ]
    }

    # Allow publishing to SNS topics.
    statement = {
        effect = "Allow"
        actions = [
            "SNS:Publish",
        ]
        resources = [
            "${aws_sns_topic.webhooks_all.arn}",
            "${aws_sns_topic.webhooks_public.arn}"
        ]
    }
}

resource "aws_iam_role_policy" "lambda_github_webhooks_receive_policy" {
    name = "lambda-github-webhooks-receive"
    role = "${aws_iam_role.lambda_github_webhooks_receive.id}"
    policy = "${data.aws_iam_policy_document.lambda_github_webhooks_receive.json}"
}

data "aws_iam_policy_document" "firehose_assume_role" {
    statement = {
        effect = "Allow"
        actions = [
            "sts:AssumeRole",
        ]
        principals {
            type = "Service"
            identifiers = [
                "firehose.amazonaws.com",
            ]
        }
    }
}

resource "aws_iam_role" "kinesis_firehose_github_webhooks" {
    name = "kinesis-firehose-github-webhooks"
    assume_role_policy = "${data.aws_iam_policy_document.firehose_assume_role.json}"
}

data "aws_iam_policy_document" "firehose_github_webhooks" {
    # Allow writing CloudWatch logs.
    statement = {
        effect = "Allow"
        actions = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
        ]
        resources = [
            "${aws_cloudwatch_log_group.kinesisfirehose_github_webhooks.arn}",
        ]
    }

    # Allow writing to S3.
    statement = {
        effect = "Allow"
        actions = [
            "s3:AbortMultipartUpload",
            "s3:GetBucketLocation",
            "s3:GetObject",
            "s3:ListBucket",
            "s3:ListBucketMultipartUploads",
            "s3:PutObject"
        ]
        resources = [
            "${aws_s3_bucket.webhooks_bucket.arn}",
            "${aws_s3_bucket.webhooks_bucket.arn}/*"
        ]
    }
}

resource "aws_iam_role_policy" "firehose_github_webhooks" {
    name = "firehose-github-webhooks-kinesis-firehose"
    role = "${aws_iam_role.kinesis_firehose_github_webhooks.id}"
    policy = "${data.aws_iam_policy_document.firehose_github_webhooks.json}"
}

resource "aws_iam_role" "lambda_github_webhooks_pulse" {
    name = "lambda-github-webhooks-pulse"
    assume_role_policy = "${data.aws_iam_policy_document.lambda_assume_role.json}"
}

data "aws_iam_policy_document" "lambda_github_webhooks_pulse" {
    # Allow writing to CloudWatch.
    statement = {
        effect = "Allow"
        actions = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
        ]
        resources = [
            "${aws_cloudwatch_log_group.lambda_pulse.arn}",
        ]
    }
}

resource "aws_iam_role_policy" "lambda_github_webhooks_pulse" {
    name = "lambda-github-webhooks-pulse"
    role = "${aws_iam_role.lambda_github_webhooks_pulse.id}"
    policy = "${data.aws_iam_policy_document.lambda_github_webhooks_pulse.json}"
}

data "aws_iam_policy_document" "sns_webhooks_all" {
    # Grant access to infosec-prod account.
    statement = {
        sid = "github_webhooks_all_infosec_subscribe"
        effect = "Allow"
        actions = [
            "SNS:ListSubscriptionsByTopic",
            "SNS:Subscribe",
        ]
        resources = [
            "${aws_sns_topic.webhooks_all.arn}",
        ]
        principals {
            type = "AWS"
            identifiers = ["371522382791"]
        }
    }
}
