# Per-region S3 buckets hold bundle objects. Each region should be
# identically configured except for the per-region differences.

resource "aws_s3_bucket" "hg_bundles_use1" {
    # Buckets are pinned to a specific region and therefore have to use
    # an explicit provider for that region.
    provider = "aws.use1"
    bucket = "moz-hg-bundles-us-east-1"
    acl = ""

    tags {
        App = "hgmo"
        Env = "prod"
        Owner = "gps@mozilla.com"
        Bugid = "1041173"
    }

    # Serve the auto-generated index when / is requested.
    website {
        index_document = "index.html"
    }

    # Send access logs to S3 so we can audit and monitor.
    logging {
        target_bucket = "moz-devservices-logging-us-east-1"
        target_prefix = "s3/hg-bundles/"
    }

    # Objects automatically expire after 1 week.
    lifecycle_rule {
        enabled = true
        prefix = ""
        expiration {
            days = 7
        }
        noncurrent_version_expiration {
            days = 1
        }
    }
}

resource "aws_s3_bucket_policy" "hg_bundles_use1" {
    provider = "aws.use1"
    bucket = "${aws_s3_bucket.hg_bundles_use1.bucket}"
    policy = "${data.aws_iam_policy_document.hg_bundles_use1.json}"
}

resource "aws_s3_bucket" "hg_bundles_usw1" {
    provider = "aws.usw1"
    bucket = "moz-hg-bundles-us-west-1"
    acl = ""

    tags {
        App = "hgmo"
        Env = "prod"
        Owner = "gps@mozilla.com"
        Bugid = "1041173"
    }

    website {
        index_document = "index.html"
    }

    logging {
        target_bucket = "moz-devservices-logging-us-west-1"
        target_prefix = "s3/hg-bundles/"
    }

    lifecycle_rule {
        enabled = true
        prefix = ""
        expiration {
            days = 7
        }
        noncurrent_version_expiration {
            days = 1
        }
    }
}

resource "aws_s3_bucket_policy" "hg_bundles_usw1" {
    provider = "aws.usw1"
    bucket = "${aws_s3_bucket.hg_bundles_usw1.bucket}"
    policy = "${data.aws_iam_policy_document.hg_bundles_usw1.json}"
}

resource "aws_s3_bucket" "hg_bundles_usw2" {
    provider = "aws.usw2"
    bucket = "moz-hg-bundles-us-west-2"
    acl = ""

    tags {
        App = "hgmo"
        Env = "prod"
        Owner = "gps@mozilla.com"
        Bugid = "1041173"
    }

    website {
        index_document = "index.html"
    }

    logging {
        target_bucket = "moz-devservices-logging-us-west-2"
        target_prefix = "s3/hg-bundles/"
    }

    # Versioning shouldn't be enabled on this bucket. However, Amazon
    # won't let us turn it off because it claims a replication policy
    # is present on the bucket.
    versioning {
        enabled = true
    }

    lifecycle_rule {
        enabled = true
        prefix = ""
        expiration {
            days = 7
        }
        noncurrent_version_expiration {
            days = 1
        }
    }
}

resource "aws_s3_bucket_policy" "hg_bundles_usw2" {
    provider = "aws.usw2"
    bucket = "${aws_s3_bucket.hg_bundles_usw2.bucket}"
    policy = "${data.aws_iam_policy_document.hg_bundles_usw2.json}"
}

resource "aws_s3_bucket" "hg_bundles_euc1" {
    provider = "aws.euc1"
    bucket = "moz-hg-bundles-eu-central-1"
    acl = ""

    tags {
        App = "hgmo"
        Env = "prod"
        Owner = "gps@mozilla.com"
        Bugid = "1041173"
    }

    website {
        index_document = "index.html"
    }

    logging {
        target_bucket = "moz-devservices-logging-eu-central-1"
        target_prefix = "s3/hg-bundles/"
    }

    lifecycle_rule {
        enabled = true
        prefix = ""
        expiration {
            days = 7
        }
        noncurrent_version_expiration {
            days = 1
        }
    }
}

resource "aws_s3_bucket_policy" "hg_bundles_euc1" {
    provider = "aws.euc1"
    bucket = "${aws_s3_bucket.hg_bundles_euc1.bucket}"
    policy = "${data.aws_iam_policy_document.hg_bundles_euc1.json}"
}

# Bucket to hold data about replication events.

resource "aws_s3_bucket" "hg_events_usw2" {
    provider = "aws.usw2"
    bucket = "moz-hg-events-us-west-2"
    acl = ""

    tags {
        App = "hgmo"
        Env = "prod"
        Owner = "gps@mozilla.com"
        Bugid = "1316952"
    }

    logging = {
        target_bucket = "moz-devservices-logging-us-west-2"
        target_prefix = "s3/hg-events/"
    }
}

resource "aws_s3_bucket_policy" "hg_events_usw2" {
    provider = "aws.usw2"
    bucket = "${aws_s3_bucket.hg_events_usw2.bucket}"
    policy = "${data.aws_iam_policy_document.s3_hg_events_usw2.json}"
}
