resource "aws_sns_topic" "webhooks_all" {
    name = "github-webhooks-all"
}

resource "aws_sns_topic_policy" "webhooks_all" {
    arn = "${aws_sns_topic.webhooks_all.arn}"
    policy = "${data.aws_iam_policy_document.sns_webhooks_all.json}"
}

resource "aws_sns_topic" "webhooks_public" {
    name = "github-webhooks-public"
}

resource "aws_sns_topic_subscription" "public_webhooks_to_pulse" {
    topic_arn = "${aws_sns_topic.webhooks_public.arn}"
    protocol = "lambda"
    endpoint = "${aws_lambda_function.lambda_pulse.arn}"
}
