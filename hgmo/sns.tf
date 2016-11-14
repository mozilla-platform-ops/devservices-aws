resource "aws_sns_topic" "events" {
    name = "hgmo-events"
    display_name = "Pushes and other repository events on hg.mozilla.org"
}

resource "aws_sns_topic_policy" "events" {
    arn = "${aws_sns_topic.events.arn}"
    policy = "${data.aws_iam_policy_document.sns_subscribe_events.json}"
}
