resource "aws_lambda_function" "lambda_receive" {
    s3_bucket = "${aws_s3_bucket.webhooks_bucket.bucket}"
    s3_key = "github_lambda.zip"
    function_name = "github-webhooks-receive"
    handler = "lambda_receive.handler"
    role = "${aws_iam_role.lambda_github_webhooks_receive.arn}"
    description = "Handles incoming GitHub web hooks"
    runtime = "python2.7"
    memory_size = 128
    timeout = 5
}

resource "aws_lambda_function" "lambda_pulse" {
    s3_bucket = "${aws_s3_bucket.webhooks_bucket.bucket}"
    s3_key = "github_lambda.zip"
    function_name = "github-webhooks-pulse"
    handler = "lambda_pulse.handler"
    role = "${aws_iam_role.lambda_github_webhooks_pulse.arn}"
    description = "Publish GitHub web hooks to Pulse"
    runtime = "python2.7"
    memory_size = 128
    timeout = 20
}

resource "aws_lambda_permission" "allow_api_gateway" {
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.lambda_receive.function_name}"
    principal = "apigateway.amazonaws.com"
    statement_id = "AllowExecutionFromApiGateway"
    source_arn = "arn:aws:execute-api:${var.region}:699292812394:${aws_api_gateway_rest_api.webhooks.id}/*/${aws_api_gateway_integration.webhook_post_lambda.integration_http_method}${aws_api_gateway_resource.webhook.path}"
}
