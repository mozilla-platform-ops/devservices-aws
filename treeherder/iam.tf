resource "aws_iam_user" "cdawson" {
    name = "cdawson"
}

resource "aws_iam_user" "emorley" {
    name = "emorley"
}

resource "aws_iam_user" "jgraham" {
    name = "jgraham"
}

resource "aws_iam_user" "wlachance" {
    name = "wlachance"
}

resource "aws_iam_group" "treeherder_rds_access-group" {
    name = "treeherder_rds_access-group"
}

resource "aws_iam_group_membership" "treeherder_rds_access-groupmem" {
    name = "treeherder_rds_access-group-membership"
    group = "${aws_iam_group.treeherder_rds_access-group.name}"
    users = [
        "${aws_iam_user.cdawson.name}",
        "${aws_iam_user.emorley.name}",
        "${aws_iam_user.jgraham.name}",
        "${aws_iam_user.wlachance.name}"
    ]
}

resource "aws_iam_group_policy_attachment" "manage_creds" {
    group = "${aws_iam_group.treeherder_rds_access-group.name}"
    policy_arn = "${data.terraform_remote_state.base.manage_creds_arn}"
}
resource "aws_iam_group_policy_attachment" "access_support" {
    group = "${aws_iam_group.treeherder_rds_access-group.name}"
    policy_arn = "${data.terraform_remote_state.base.access_support_arn}"
}
resource "aws_iam_group_policy_attachment" "cloudwatchaccess" {
    group = "${aws_iam_group.treeherder_rds_access-group.name}"
    policy_arn = "${data.terraform_remote_state.base.cloudwatchaccess_arn}"
}

resource "aws_iam_group_policy" "treeherder_rds-policy" {
    name = "treeherder_rds-policy"
    group = "${aws_iam_group.treeherder_rds_access-group.name}"
    policy = "${data.aws_iam_policy_document.treeherder_rds.json}"
}

data "aws_iam_policy_document" "treeherder_rds" {
    statement {
        sid = "DenyRDSFootGuns"
        effect = "Deny"
        actions = [
            "rds:AddTagsToResource",
            "rds:RemoveTagsFromResource",
            "rds:DeleteDBInstance",
            "rds:DeleteDBParameterGroup",
            "rds:DeleteDBSnapshot",
            "rds:DeleteDBSubnetGroup",
            "rds:ModifyDBSubnetGroup"
        ]
        resources = [
            "arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:db:treeherder-prod",
            "arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:db:treeherder-stage",
            "arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:pg:treeherder",
            "arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:pg:treeherder-prod",
            "arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:ri:treeherder-prod",
            "arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:ri:treeherder-stage",
            "arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:snapshot:rds:treeherder-prod",
            "arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:snapshot:rds:treeherder-stage",
            "arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:subgrp:treeherder-dbgrp"
        ]
    }
    statement {
        sid = "AllowProdDBManage"
        effect = "Allow"
        actions = [
            "rds:ApplyPendingMaintenanceAction",
            "rds:CopyDBParameterGroup",
            "rds:CopyDBSnapshot",
            "rds:CopyOptionGroup",
            "rds:CreateEventSubscription",
            "rds:DeleteEventSubscription",
            "rds:Describe",
            "rds:DownloadCompleteDBLogFile",
            "rds:DownloadDBLogFilePortion",
            "rds:ListTagsForResource",
            "rds:ModifyEventSubscription",
            "rds:RebootDBInstance"
        ]
        resources = [
            "arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:db:treeherder-prod",
            "arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:db:treeherder-stage",
            "arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:pg:treeherder",
            "arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:pg:treeherder-prod",
            "arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:ri:treeherder-prod",
            "arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:ri:treeherder-stage",
            "arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:snapshot:rds:treeherder-prod",
            "arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:snapshot:rds:treeherder-stage",
            "arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:subgrp:treeherder-dbgrp"
        ]
    }
    statement {
        sid = "AllowDevDBManage"
        effect = "Allow"
        actions = [
            "rds:ApplyPendingMaintenanceAction",
            "rds:AddTagsToResource",
            "rds:CopyDBParameterGroup",
            "rds:CopyDBSnapshot",
            "rds:CopyOptionGroup",
            "rds:CreateDBInstance",
            "rds:CreateDBParameterGroup",
            "rds:CreateDBSnapshot",
            "rds:CreateEventSubscription",
            "rds:CreateOptionGroup",
            "rds:DeleteEventSubscription",
            "rds:DeleteDBInstance",
            "rds:DeleteDBParameterGroup",
            "rds:DeleteDBSnapshot",
            "rds:DeleteOptionGroup",
            "rds:Describe*",
            "rds:DownloadCompleteDBLogFile",
            "rds:DownloadDBLogFilePortion",
            "rds:ListTagsForResource",
            "rds:ModifyDBInstance",
            "rds:ModifyDBParameterGroup",
            "rds:ModifyEventSubscription",
            "rds:ModifyOptionGroup",
            "rds:RebootDBInstance",
            "rds:RestoreDBInstanceFromDBSnapshot",
            "rds:RestoreDBInstanceToPointInTime",
            "rds:ResetDBParameterGroup"
        ]
        resources = [
            "arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:db:treeherder-dev*",
            "arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:og:treeherder-dev*",
            "arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:pg:treeherder-dev*",
            "arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:snapshot:treeherder-*",
            "arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:es:treeherder-*",
            "arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:ri:treeherder-dev*",
            "arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:subgrp:treeherder-dbgrp"
        ]
    }
    statement {
        effect = "Allow"
        actions = [
            "iam:ListAttachedUserPolicies",
            "iam:ListPolicies",
            "iam:ListRoles",
            "rds:Describe*",
            "rds:ListTagsForResource",
            "ec2:DescribeAvailabilityZones",
            "ec2:DescribeVpcs",
            "ec2:DescribeAccountAttributes",
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeSubnets",
            "sns:*"
        ]
        resources = ["*"]
    }
}
