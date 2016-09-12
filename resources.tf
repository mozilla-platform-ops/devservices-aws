# This file contains shared global resources

# account_id = ${data.aws_caller_identity.current.account_id}
data "aws_caller_identity" "current" { }

# Configure remote state
# outputs can be accessed via ${terraform_remote_state.base.output_name}
data "terraform_remote_state" "base" {
    backend = "s3"
    config {
        encrypt = true
        acl = "private"
        bucket = "${var.base_bucket}"
        region = "us-east-1"
        key = "tf_state/base/terraform.tfstate"
    }
}
