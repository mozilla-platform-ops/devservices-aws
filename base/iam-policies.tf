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

# Access the Support Center: everyone
resource "aws_iam_policy" "access_support" {
    name = "access_support-policy"
    description = "Allow users to access the Support Center"
    policy = "${file("files/access_support.json")}"
}

resource "aws_iam_policy" "cloudwatchaccess" {
    name = "cloudwatchaccess"
    description = "Allows users to access CloudWatch resources"
    policy = "${file("files/cloudwatchaccess.json")}"
}

data "aws_iam_policy_document" "s3-ssh-keys-access" {
    statement = {
        sid = "AllowEC2ToReadKeyBucket"
        effect = "Allow"
        actions = [
            "s3:ListBucket",
        ]
        principals {
            type = "AWS"
            identifiers = [
                "${aws_iam_role.ec2-assume-role.arn}",
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/vcs-sync-servo-assume-role",
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/wpt-sync-testing-assume-role",
            ]
        }
        resources = ["${aws_s3_bucket.key_bucket.arn}"]
    }
    statement = {
        sid = "AllowEC2ToReadKeyBucketObjects"
        effect = "Allow"
        actions = [
            "s3:Get*",
            "s3:List*",
        ]
        principals {
            type = "AWS"
            identifiers = [
                "${aws_iam_role.ec2-assume-role.arn}",
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/vcs-sync-servo-assume-role",
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/wpt-sync-testing-assume-role",
            ]
        }
        resources = ["${aws_s3_bucket.key_bucket.arn}/*"]
    }
}
