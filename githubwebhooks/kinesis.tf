resource "aws_kinesis_firehose_delivery_stream" "webhooks" {
    name = "github-webhooks"
    destination = "s3"
    s3_configuration {
        role_arn = "${aws_iam_role.kinesis_firehose_github_webhooks.arn}"
        bucket_arn = "${aws_s3_bucket.webhooks_bucket.arn}"
        buffer_size = 10
        buffer_interval = 600
        prefix = "kinesis/"
        cloudwatch_logging_options {
            enabled = true
            log_group_name = "${aws_cloudwatch_log_group.kinesisfirehose_github_webhooks.name}"
            log_stream_name = "S3Delivery"
        }
    }
}
