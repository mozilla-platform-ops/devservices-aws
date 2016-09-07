resource "aws_sns_topic" "tfstate-sns_topic" {
    name = "devservices_tfstate"
}
resource "aws_sns_topic_policy" "tfstate-sns_policy" {
    arn = "${aws_sns_topic.tfstate-sns_topic.arn}"
    policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[{
        "Effect": "Allow",
        "Principal": {"Service":"s3.amazonaws.com"},
        "Action": "SNS:Publish",
        "Resource": "arn:aws:sns:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_sns_topic.tfstate-sns_topic.name}",
        "Condition":{
            "ArnLike":{"aws:SourceArn":"${aws_s3_bucket.base-bucket.arn}"}
        }
    }]
}
POLICY
}
