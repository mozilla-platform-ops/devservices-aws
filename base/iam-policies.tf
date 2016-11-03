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
