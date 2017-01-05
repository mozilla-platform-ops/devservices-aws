resource "aws_s3_bucket" "servo_state" {
    bucket = "moz-vcssync-servo-commitmap"
    acl = "private"

    tags {
        App = "VCS Sync"
        Env = "prod"
        Owner = "gps@mozilla.com"
        Bugid = "1317525"
    }

    versioning {
        enabled = true
    }

    lifecycle_rule {
        enabled = true
        prefix = ""
        noncurrent_version_expiration {
            days = 30
        }
    }
}

data "aws_iam_policy_document" "s3_servo_bucket_access" {
    statement = {
        effect = "Allow"
        actions = [
            "s3:GetObject",
            "s3:PutObject",
        ]
        resources = ["${aws_s3_bucket.servo_state.arn}/*"]
        principals {
            type = "AWS"
            identifiers = ["${aws_iam_role.servo-assume-role.arn}"]
        }
    }
}

resource "aws_s3_bucket_policy" "s3_servo_attach" {
    bucket = "${aws_s3_bucket.servo_state.bucket}"
    policy = "${data.aws_iam_policy_document.s3_servo_bucket_access.json}"
}
