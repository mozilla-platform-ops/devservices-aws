resource "aws_cloudwatch_log_group" "lambda_receive" {
    name = "/aws/lambda/github-webhooks-receive"
    retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "lambda_pulse" {
    name = "/aws/lambda/github-webhooks-pulse"
    retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "kinesisfirehose_github_webhooks" {
    name = "/aws/kinesisfirehose/github-webhooks"
    retention_in_days = 30
}
