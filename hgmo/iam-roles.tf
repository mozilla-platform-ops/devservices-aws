# This user is used to upload to S3.
resource "aws_iam_user" "hgbundler" {
    name = "hgbundler"
}

# Used to send notifications from hg.mo to SNS.
resource "aws_iam_user" "hgnotifier" {
    name = "hgnotifier"
}

# The following policies govern S3 bundles bucket access.
#
# The following policies should be identical and only vary by region.
# Unfortunately, attempting to reference resources outside the current
# region is rejected by Amazon, hence the need for multiple policies.

data "aws_iam_policy_document" "hg_bundles_use1" {
    # Grant bundler user access to upload and modify objects.
    statement = {
        effect = "Allow"
        actions = [
            "s3:DeleteObject",
            "s3:GetObject",
            "s3:PutObject",
        ]
        resources = [
            "${aws_s3_bucket.hg_bundles_use1.arn}/*",
        ]
        principals {
            type = "AWS"
            identifiers = ["${aws_iam_user.hgbundler.arn}"]
        }
    }

    # Grant all access to read S3 objects.
    statement = {
        effect = "Allow"
        actions = [
            "s3:GetObjectTorrent",
            "s3:GetObject",
        ]
        resources = [
            "${aws_s3_bucket.hg_bundles_use1.arn}/*",
        ]
        principals {
            type = "AWS"
            identifiers = ["*"]
        }
    }
}

data "aws_iam_policy_document" "hg_bundles_usw1" {
    # Grant bundler user access to upload and modify objects.
    statement = {
        effect = "Allow"
        actions = [
            "s3:DeleteObject",
            "s3:GetObject",
            "s3:PutObject",
        ]
        resources = [
            "${aws_s3_bucket.hg_bundles_usw1.arn}/*",
        ]
        principals {
            type = "AWS"
            identifiers = ["${aws_iam_user.hgbundler.arn}"]
        }
    }

    # Grant all access to read S3 objects.
    statement = {
        effect = "Allow"
        actions = [
            "s3:GetObjectTorrent",
            "s3:GetObject",
        ]
        resources = [
            "${aws_s3_bucket.hg_bundles_usw1.arn}/*",
        ]
        principals {
            type = "AWS"
            identifiers = ["*"]
        }
    }
}

data "aws_iam_policy_document" "hg_bundles_usw2" {
    # Grant bundler user access to upload and modify objects.
    statement = {
        effect = "Allow"
        actions = [
            "s3:DeleteObject",
            "s3:GetObject",
            "s3:PutObject",
        ]
        resources = [
            "${aws_s3_bucket.hg_bundles_usw2.arn}/*",
        ]
        principals {
            type = "AWS"
            identifiers = ["${aws_iam_user.hgbundler.arn}"]
        }
    }

    # Grant all access to read S3 objects.
    statement = {
        effect = "Allow"
        actions = [
            "s3:GetObjectTorrent",
            "s3:GetObject",
        ]
        resources = [
            "${aws_s3_bucket.hg_bundles_usw2.arn}/*",
        ]
        principals {
            type = "AWS"
            identifiers = ["*"]
        }
    }
}

data "aws_iam_policy_document" "hg_bundles_euc1" {
    # Grant bundler user access to upload and modify objects.
    statement = {
        effect = "Allow"
        actions = [
            "s3:DeleteObject",
            "s3:GetObject",
            "s3:PutObject",
        ]
        resources = [
            "${aws_s3_bucket.hg_bundles_euc1.arn}/*",
        ]
        principals {
            type = "AWS"
            identifiers = ["${aws_iam_user.hgbundler.arn}"]
        }
    }

    # Grant all access to read S3 objects.
    statement = {
        effect = "Allow"
        actions = [
            "s3:GetObjectTorrent",
            "s3:GetObject",
        ]
        resources = [
            "${aws_s3_bucket.hg_bundles_euc1.arn}/*",
        ]
        principals {
            type = "AWS"
            identifiers = ["*"]
        }
    }
}

# Allow the hgnotifier user to publish to the SNS topic.

data "aws_iam_policy_document" "sns_publish_events" {
    statement = {
        effect = "Allow"
        actions = [
            "SNS:Publish",
        ]
        resources = [
            "${aws_sns_topic.events.arn}",
        ]
    }
}

resource "aws_iam_user_policy" "hgnotifier-sns-publish" {
    name = "sns-events-publish"
    user = "${aws_iam_user.hgnotifier.name}"
    policy = "${data.aws_iam_policy_document.sns_publish_events.json}"
}

# Allow anybody to subscribe to the SNS topic.

data "aws_iam_policy_document" "sns_subscribe_events" {
    statement = {
        effect = "Allow"
        actions = [
            "SNS:Subscribe",
        ]
        resources = [
            "${aws_sns_topic.events.arn}",
        ]
        principals {
            type = "AWS"
            identifiers = ["*"]
        }
    }
}

data "aws_iam_policy_document" "s3_hg_events_usw2" {
    # Grant notifier user access to upload objects.
    statement = {
        effect = "Allow"
        actions = [
            "s3:GetObject",
            "s3:PutObject",
        ]
        resources = [
            "${aws_s3_bucket.hg_events_usw2.arn}/*",
        ]
        principals {
            type = "AWS"
            identifiers = ["${aws_iam_user.hgnotifier.arn}"]
        }
    }

    # Grant all access to read S3 objects.
    statement = {
        effect = "Allow"
        actions = [
            "s3:GetObject",
        ]
        resources = [
            "${aws_s3_bucket.hg_events_usw2.arn}/*",
        ]
        principals {
            type = "AWS"
            identifiers = ["*"]
        }
    }
}
