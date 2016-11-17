resource "aws_iam_user" "dkl" {
    name = "dkl"
}

resource "aws_iam_user" "dylan" {
    name = "dylan"
}

resource "aws_iam_user" "glob" {
    name = "glob"
}

resource "aws_iam_group" "bmo_devs" {
    name = "bmo_devs"
}

resource "aws_iam_group_membership" "bmo_devs-groupmem" {
    name = "bmo_devs-group-membership"
    group = "${aws_iam_group.bmo_devs.name}"
    users = [
        "${aws_iam_user.dkl.name}",
        "${aws_iam_user.dylan.name}",
        "${aws_iam_user.glob.name}"
    ]
}

resource "aws_iam_group_policy_attachment" "manage_creds" {
    group = "${aws_iam_group.bmo_devs.name}"
    policy_arn = "${data.terraform_remote_state.base.manage_creds_arn}"
}
resource "aws_iam_group_policy_attachment" "access_support" {
    group = "${aws_iam_group.bmo_devs.name}"
    policy_arn = "${data.terraform_remote_state.base.access_support_arn}"
}
resource "aws_iam_group_policy_attachment" "cloudwatchaccess" {
    group = "${aws_iam_group.bmo_devs.name}"
    policy_arn = "${data.terraform_remote_state.base.cloudwatchaccess_arn}"
}

resource "aws_iam_group_policy" "bmo_devs_s3_access" {
    name = "bmo_devs_s3_access"
    group = "${aws_iam_group.bmo_devs.name}"
    policy = "${data.aws_iam_policy_document.bmo_dev_s3_access.json}"
}

# Allow full access to BMO Carton bucket; BMO Devs
data "aws_iam_policy_document" "bmo_dev_s3_access" {
    statement {
        sid = "AllowListAccessToBugzillaCartons"
        effect = "Allow"
        actions = [
            "s3:ListBucket"
        ]
        resources = [
            "${aws_s3_bucket.carton_bucket.arn}"
        ]
    }
    statement {
        sid = "AllowFullAccessToBugzillaCartons"
        effect = "Allow"
        actions = [
            "s3:PutObject",
            "s3:GetObject",
            "s3:GetObjectVersion",
            "s3:DeleteObject",
            "s3:DeleteObjectVersion"
        ]
        resources = [
            "${aws_s3_bucket.carton_bucket.arn}/*"
        ]
    }
}

# role account for bugzilla dev attachments (#1310041)
resource "aws_iam_user" "bugzilla_dev" {
    name = "bugzilla_dev"
}
