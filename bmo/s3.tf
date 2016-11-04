variable "carton_bucket" {
    default = "moz-devservices-bmocartons"
    description = "Bucket for storing perl carton tarballs"
}

resource "aws_s3_bucket" "carton_bucket" {
    bucket = "${var.carton_bucket}"
    policy = "${data.aws_iam_policy_document.carton_public_s3_access.json}"
    versioning {
        enabled = true
    }
    logging {
        target_bucket = "${var.logging_bucket}"
        target_prefix = "s3/bmocartons/"
    }
    tags {
        Name = "Bugzilla Perl Cartons"
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
            "arn:aws:s3:::${var.carton_bucket}"
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
            "arn:aws:s3:::${var.carton_bucket}/*"
        ]
        # https://github.com/hashicorp/terraform/issues/9335
        principals {
            type = "*"
            identifiers = ["*"]
        }
    }
}
