# This file contains shared global resources

# Configure remote state
# outputs can be accessed via ${terraform_remote_state.base.output_name}
data "terraform_remote_state" "base" {
    backend = "s3"
    config {
        encrypt = true
        acl = "private"
        bucket = "${var.base_bucket}"
        region = "${var.region}"
        key = "tf_state/base/terraform.tfstate"
    }
}
