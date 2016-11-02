# This user is used to upload to S3.
resource "aws_iam_user" "hgbundler" {
    name = "hgbundler"
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
