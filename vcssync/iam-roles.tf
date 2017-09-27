data "aws_iam_policy_document" "ec2_assume_role" {
    statement {
        actions = ["sts:AssumeRole"]
        effect = "Allow"
        principals {
            type = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
    }
}

resource "aws_iam_instance_profile" "servo" {
    name = "vcs-sync-servo"
    role = "${aws_iam_role.servo-assume-role.name}"
}

resource "aws_iam_role" "servo-assume-role" {
    name = "vcs-sync-servo-assume-role"
    assume_role_policy = "${data.aws_iam_policy_document.ec2_assume_role.json}"
}

data "aws_iam_policy_document" "servo_ec2_instance_policy" {
    # Read access to SSH keys in S3.
    statement = {
        effect = "Allow"
        actions = [
            "s3:Get*",
            "s3:List*",
        ]
        resources = [
            "arn:aws:s3:::${data.terraform_remote_state.base.key_bucket_id}/*",
        ]
    }

    # Read/Write access to Servo's state bucket.
    statement = {
        effect = "Allow"
        actions = [
            "s3:GetObject",
            "s3:PutObject",
        ]
        resources = [
            "${aws_s3_bucket.servo_state.arn}/*",
        ]
    }

    # Write CloudWatch log events.
    statement = {
        effect = "Allow"
        actions = [
            "logs:CreateLogStream",
            "logs:DescribeLogStreams",
            "logs:PutLogEvents",
        ]
        resources = [
            "${aws_cloudwatch_log_group.vcssync.arn}",
            "${aws_cloudwatch_log_group.vcssync.arn}:log-stream:${aws_instance.servo_vcs_sync.id}",
        ]
    }

    # Publish to Servo errors SNS topic.
    statement = {
        effect = "Allow"
        actions = [
            "SNS:Publish",
        ]
        resources = [
            "${aws_sns_topic.servo_errors.arn}",
        ]
    }
}

resource "aws_iam_role_policy" "vcs-sync-servo" {
    name = "vcs-sync-servo"
    role = "${aws_iam_role.servo-assume-role.id}"
    policy = "${data.aws_iam_policy_document.servo_ec2_instance_policy.json}"
}

data "aws_iam_policy_document" "sns_servo_errors_subscribe" {
    statement = {
        effect = "Allow"
        actions = [
            "SNS:Subscribe",
        ]
        resources = [
            "${aws_sns_topic.servo_errors.arn}",
        ]
        principals {
            type = "AWS"
            identifiers = ["*"]
        }
    }
}

resource "aws_iam_instance_profile" "wpt-sync-testing" {
    name = "wpt-sync-testing"
    role = "${aws_iam_role.wpt-sync-testing-assume-role.name}"
}

data "aws_iam_policy_document" "wpt_sync_instance_policy" {
    statement = {
        effect = "Allow"
        actions = [
            "s3:Get*",
            "s3:List*",
        ]
        resources = [
            "arn:aws:s3:::${data.terraform_remote_state.base.key_bucket_id}/*",
        ]
    }
}

resource "aws_iam_role" "wpt-sync-testing-assume-role" {
    name = "wpt-sync-testing-assume-role"
    assume_role_policy = "${data.aws_iam_policy_document.ec2_assume_role.json}"
}

resource "aws_iam_role_policy" "wpt-sync-testing" {
    name = "wpt-sync-testing"
    role = "${aws_iam_role.wpt-sync-testing-assume-role.id}"
    policy = "${data.aws_iam_policy_document.wpt_sync_instance_policy.json}"
}
