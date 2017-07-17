resource "aws_sns_topic" "servo_errors" {
    name = "vcssync-servo-errors"
    display_name = "Errors encountered during Servo VCS Sync operations"
}

resource "aws_sns_topic_policy" "servo_errors" {
    arn = "${aws_sns_topic.servo_errors.arn}"
    policy = "${data.aws_iam_policy_document.sns_servo_errors_subscribe.json}"
}
