variable "carton_bucket" {
    default = "moz-devservices-bmocartons"
    description = "Bucket for storing perl carton tarballs"
}

variable "dev_attachment_bucket" {
    default = "moz-bugzilladev-attach"
    description = "Bucket for storing attachments (dev)"
}

resource "aws_s3_bucket" "dev_attachment_bucket" {
    bucket = "${var.dev_attachment_bucket}"
    policy = "${data.aws_iam_policy_document.dev_attachment_bucket_access.json}"
    logging {
        target_bucket = "${var.logging_bucket}"
        target_prefix = "s3/bugzilla_dev_attach/"
    }
    tags {
        Name = "bugzilla-dev-s3"
        App = "bugzilla"
        Env = "dev"
        Owner = "relops"
        BugId = "1310041"
    }
}

data "aws_iam_policy_document" "dev_attachment_bucket_access" {
    statement {
        sid = "BugzillaDevS3AttachmentBucket"
        effect = "Allow"
        actions = [
            "s3:ListBucket"
        ]
        resources = [
            "arn:aws:s3:::${var.dev_attachment_bucket}"
        ]
        principals {
            type = "AWS"
            identifiers = ["${aws_iam_user.bugzilla_dev.arn}"]
        }
    }
    statement {
        sid = "BugzillaDevS3AttachmentObjects"
        effect = "Allow"
        actions = [
            "s3:DeleteObject",
            "s3:GetObject",
            "s3:PutObject"
        ]
        resources = [
            "arn:aws:s3:::${var.dev_attachment_bucket}/*"
        ]
        principals {
            type = "AWS"
            identifiers = ["${aws_iam_user.bugzilla_dev.arn}"]
        }
    }
}

variable "prod_attachment_bucket" {
    default = "moz-bugzillaprod-attach"
    description = "Bucket for storing attachments (prod)"
}

resource "aws_s3_bucket" "prod_attachment_bucket" {
    bucket = "${var.prod_attachment_bucket}"
    policy = "${data.aws_iam_policy_document.prod_attachment_bucket_access.json}"
    logging {
        target_bucket = "${var.logging_bucket}"
        target_prefix = "s3/bugzilla_prod_attach/"
    }
    tags {
        Name = "bugzilla-prod-s3"
        App = "bugzilla"
        Env = "prod"
        Owner = "relops"
        BugId = "1328659"
    }
}

data "aws_iam_policy_document" "prod_attachment_bucket_access" {
    statement {
        sid = "BugzillaProdS3AttachmentBucket"
        effect = "Allow"
        actions = [
            "s3:ListBucket"
        ]
        resources = [
            "arn:aws:s3:::${var.prod_attachment_bucket}"
        ]
        principals {
            type = "AWS"
            identifiers = ["${aws_iam_user.bugzilla_prod.arn}"]
        }
    }
    statement {
        sid = "BugzillaProdS3AttachmentObjects"
        effect = "Allow"
        actions = [
            "s3:DeleteObject",
            "s3:GetObject",
            "s3:PutObject"
        ]
        resources = [
            "arn:aws:s3:::${var.prod_attachment_bucket}/*"
        ]
        principals {
            type = "AWS"
            identifiers = ["${aws_iam_user.bugzilla_prod.arn}"]
        }
    }
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
