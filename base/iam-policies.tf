# pre-existing policies
# vcssync-s3-log-writer-releng
# vcssync-s3-log-writer
# vcs-archive-full-access

# Manage own credentials; everyone
resource "aws_iam_policy" "manage_own_credentials" {
    name = "manage_own_credentials-policy"
    description = "Allows users to manage their own credentials"
    policy = "${file("files/manage_own_credentials.json")}"
}
resource "aws_iam_group_policy_attachment" "bmo_manage_creds-attach" {
    group = "${aws_iam_group.bmodevs-group.name}"
    policy_arn = "${aws_iam_policy.manage_own_credentials.arn}"
}

# Access the Support Center: everyone
resource "aws_iam_policy" "access_support" {
    name = "access_support-policy"
    description = "Allow users to access the Support Center"
    policy = "${file("files/access_support.json")}"
}
resource "aws_iam_group_policy_attachment" "bmo_support-attach" {
    group = "${aws_iam_group.bmodevs-group.name}"
    policy_arn = "${aws_iam_policy.access_support.arn}"
}

resource "aws_iam_policy" "cloudwatchaccess" {
    name = "cloudwatchaccess"
    description = "Allows users to access CloudWatch resources"
    policy = "${file("files/cloudwatchaccess.json")}"
}

# Allow full access to BMO Carton bucket; BMO Devs
resource "aws_iam_policy" "bugzillacarton_devs-policy" {
    name = "bugzillacarton_devs-policy"
    description = "Allow full access to Bugzilla carton bucket"
    policy = "${file("files/s3-bugzillacarton-devs.json")}"
}
resource "aws_iam_policy_attachment" "bugzillacarton_devs-attach" {
    name = "bugzillacarton_devs-attach"
    groups = ["${aws_iam_group.bmodevs-group.name}"]
    policy_arn = "${aws_iam_policy.bugzillacarton_devs-policy.arn}"
}
