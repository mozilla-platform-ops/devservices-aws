# Render policy to allow EC2 assumed role to read base bucket
data "template_file" "base_bucket-template" {
    template = "${file("files/s3_base_bucket.json.tmpl")}"
    vars {
        account_id = "${var.account_id}"
        key_bucket = "${var.base_bucket}"
        ec2_assume_role = "${aws_iam_role.ec2-assume-role.name}"
        ec2_manage_eip_role = "${aws_iam_role.ec2_manage_eip-role.name}"
    }
}

# Create base bucket for SSH pub keys, user-data scripts, etc
resource "aws_s3_bucket" "base-bucket" {
    bucket = "${var.base_bucket}"
    acl = "private"
    policy = "${data.template_file.base_bucket-template.rendered}"
    versioning {
        enabled = true
    }
    logging {
        target_bucket = "${var.logging_bucket}"
        target_prefix = "s3/${var.base_bucket}/"
    }
    tags {
        Name = "base-ops-s3"
        App = "base"
        Env = "ops"
        Type = "s3"
        Owner = "relops"
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

# Manage SSH public keys
resource "aws_s3_bucket_object" "ssh_pub_keys" {
    bucket = "${var.base_bucket}"
    count = "${length(split(",", var.ssh_key_names))}"
    key = "pubkeys/${element(split(",", var.ssh_key_names), count.index)}"
    content = "${file("files/public_keys/${element(split(",", var.ssh_key_names), count.index)}.pub")}"
    depends_on = ["aws_s3_bucket.base-bucket"]
}

# Manage user-data scripts (see below for ssh-pubkeys.tmpl)
resource "aws_s3_bucket_object" "user-data" {
    bucket = "${var.base_bucket}"
    count = "${length(split(",", var.user_data_scripts))}"
    key = "user-data/${element(split(",", var.user_data_scripts), count.index)}"
    content = "${file("files/user-data/${element(split(",", var.user_data_scripts), count.index)}")}"
    depends_on = ["aws_s3_bucket.base-bucket"]
}

# user-data template scripts need extra effort
data "template_file" "s3_userdata_pubkeys-template" {
    template = "${file("files/user-data/ssh-pubkeys.tmpl")}"
    vars {
        base_bucket = "${var.base_bucket}"
        pubkey_bucket_prefix = "${var.pubkey_bucket_prefix}"
    }
}
resource "aws_s3_bucket_object" "pubkeys-user-data" {
    bucket = "${var.base_bucket}"
    key = "user-data/ssh-pubkeys"
    content = "${data.template_file.s3_userdata_pubkeys-template.rendered}"
    depends_on = ["aws_s3_bucket.base-bucket", "data.template_file.s3_userdata_pubkeys-template"]
}

# To be deprecated
resource "aws_s3_bucket" "key_bucket" {
    bucket = "moz-devservices-keys"
    acl = "private"
    logging {
        target_bucket = "${var.logging_bucket}"
        target_prefix = "s3/ssh_pub_keys/"
    }
    tags {
        Name = "base-ops-s3"
        App = "base"
        Env = "ops"
        Type = "s3"
        Owner = "relops"
    }
}

resource "aws_s3_bucket_policy" "keys_bucket" {
    bucket = "${aws_s3_bucket.key_bucket.bucket}"
    policy = "${data.aws_iam_policy_document.s3-ssh-keys-access.json}"
}

resource "aws_s3_bucket_object" "ssh_keys" {
    bucket = "${aws_s3_bucket.key_bucket.bucket}"
    key = "${element(split(",", var.ssh_key_names), count.index)}.pub"
    content = "${file("files/public_keys/${element(split(",", var.ssh_key_names), count.index)}.pub")}"
    count = "${length(split(",", var.ssh_key_names))}"
    depends_on = ["aws_s3_bucket.key_bucket"]
}
