resource "aws_s3_bucket" "base-bucket" {
    bucket = "${var.base_bucket}"
    acl = "private"
    versioning {
        enabled = true
    }
    logging {
        target_bucket = "${var.logging_bucket}"
        target_prefix = "s3/${var.base_bucket}/"
    }
    tags {
        Name = "terraform state bucket"
        Env = "shared"
    }
}
resource "aws_s3_bucket_notification" "base_bucket-notify" {
    bucket = "${aws_s3_bucket.base-bucket.id}"
    topic {
        topic_arn = "${aws_sns_topic.tfstate-sns_topic.arn}"
        events = ["s3:ObjectCreated:*"]
        filter_prefix = "tf_state/"
    }
}

resource "aws_s3_bucket" "key_bucket" {
    bucket = "moz-devservices-keys"
    acl = "private"
    policy = "${file("files/s3-keys-bucket.json")}"
    logging {
        target_bucket = "${var.logging_bucket}"
        target_prefix = "s3/ssh_pub_keys/"
    }
    tags {
        Name = "SSH public keys"
    }
}

variable "ssh_key_names" {
    default = "gszorc1,gszorc2,hwine1,klibby2"
}
resource "aws_s3_bucket_object" "ssh_keys" {
    bucket = "${aws_s3_bucket.key_bucket.bucket}"
    key = "${element(split(",", var.ssh_key_names), count.index)}.pub"
    content = "${file("files/public_keys/${element(split(",", var.ssh_key_names), count.index)}.pub")}"
    count = "${length(split(",", var.ssh_key_names))}"
    depends_on = ["aws_s3_bucket.key_bucket"]
}
