# pre-existing policies
# vcssync-s3-log-writer-releng
# vcssync-s3-log-writer
# vcs-archive-full-access

# Manage own credentials; everyone
resource "aws_iam_policy" "manage_own_credentials-policy" {
    name = "manage_own_credentials-policy"
    description = "Allows users to manage their own credentials"
    policy = "${file("files/manage_own_credentials.json")}"
}
resource "aws_iam_policy_attachment" "manage_own_credentials-attach" {
    name = "manage_own_credentials-attach"
    groups = ["${aws_iam_group.netops-group.name}",
              "${aws_iam_group.bmodevs-group.name}",
              "${aws_iam_group.treeherder_rds_access-group.name}"]
    policy_arn = "${aws_iam_policy.manage_own_credentials-policy.arn}"
}
# Access the Support Center: everyone
resource "aws_iam_policy" "access_support-policy" {
    name = "access_support-policy"
    description = "Allow users to access the Support Center"
    policy = "${file("files/access_support.json")}"
}
resource "aws_iam_policy_attachment" "access_support-attach" {
    name = "access_support-attach"
    groups = ["${aws_iam_group.netops-group.name}",
              "${aws_iam_group.bmodevs-group.name}",
              "${aws_iam_group.treeherder_rds_access-group.name}"]
    policy_arn = "${aws_iam_policy.access_support-policy.arn}"
}

# Treeherder RDS access; Treeherder Devs
resource "aws_iam_policy" "treeherder_rds-policy" {
    name = "treeherder_rds-policy"
    description = "Allows users access the Treeherder RDS resources"
    policy = "${file("files/treeherder_rds.json")}"
}
resource "aws_iam_policy_attachment" "treeherder_rds-attach" {
    name = "treeherder_rds-attach"
    groups = ["${aws_iam_group.treeherder_rds_access-group.name}"]
    policy_arn = "${aws_iam_policy.treeherder_rds-policy.arn}"
}

# Access CloudWatch resources; Treeherder Devs
resource "aws_iam_policy" "cloudwatchaccess-policy" {
    name = "cloudwatchaccess-policy"
    description = "Allows users to access CloudWatch resources"
    policy = "${file("files/cloudwatchaccess.json")}"
}
resource "aws_iam_policy_attachment" "cloudwatchaccess-attach" {
    name = "cloudwatchaccess-attach"
    groups = ["${aws_iam_group.treeherder_rds_access-group.name}"]
    policy_arn = "${aws_iam_policy.cloudwatchaccess-policy.arn}"
}

# Additional read-only access for netops
resource "aws_iam_policy" "netops_additional-policy" {
    name = "netops_additional-policy"
    description = "Additional read-ony access for netops"
    policy = "${file("files/netops_additional.json")}"
}
resource "aws_iam_policy_attachment" "netops_additional-attach" {
    name = "netops_additional-attach"
    groups = ["${aws_iam_group.netops-group.name}"]
    policy_arn = "${aws_iam_policy.netops_additional-policy.arn}"
}

# AmazonVPCFullAccess; NetOps
resource "aws_iam_policy_attachment" "vpcfullaccess-attach" {
    name = "vpcfullaccess-attach"
    groups = ["${aws_iam_group.netops-group.name}"]
    policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
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
