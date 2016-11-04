resource "aws_s3_bucket" "carton_bucket" {
    bucket = "moz-devservices-bmocartons"
    policy = "${file("files/s3-bugzillacarton-public.json")}"
    versioning {
        enabled = true
    }
    logging {
        target_bucket = "${var.logging_bucket}"
        target_prefix = "s3/bmocartons/"
    }
    tags {
        Name = "bugzilla-ops-s3"
        App = "bugzilla"
        Env = "ops"
        Owner = "relops"
        BugId = "1254582"
    }
}

data "aws_iam_policy_document" "carton_public_s3_access" {
    statement {
        sid = "AllowPublicListAccessToBugzillaCartons"
        effect = "Allow"
        actions = [
            "s3:ListBucket"
        ]
        resources = [
            "${aws_s3_bucket.carton_bucket.arn}"
        ]
        # https://github.com/hashicorp/terraform/issues/9335
        principals {
            type = "*"
            identifiers = ["*"]
        }
    }
    statement {
        sid = "AllowPublicAccessToBugzillaCartons"
        effect = "Allow"
        actions = [
            "s3:GetObject",
            "s3:GetObjectVersion"
        ]
        resources = [
            "${aws_s3_bucket.carton_bucket.arn}/*"
        ]
        # https://github.com/hashicorp/terraform/issues/9335
        principals {
            type = "*"
            identifiers = ["*"]
        }
    }
}
