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
    roles = ["${aws_iam_role.servo-assume-role.name}"]
}

resource "aws_iam_role" "servo-assume-role" {
    name = "vcs-sync-servo-assume-role"
    assume_role_policy = "${data.aws_iam_policy_document.ec2_assume_role.json}"
}

data "aws_iam_policy_document" "s3_servo_state_access" {
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
}

resource "aws_iam_role_policy" "vcs-sync-servo" {
    name = "vcs-sync-servo"
    role = "${aws_iam_role.servo-assume-role.id}"
    policy = "${data.aws_iam_policy_document.s3_servo_state_access.json}"
}
