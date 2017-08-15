# This file contains shared global resources

terraform {
    required_version = ">= 0.10.0"
}

# account_id = ${data.aws_caller_identity.current.account_id}
data "aws_caller_identity" "current" { }

data "aws_availability_zones" "available" {}

# Configure remote state
# outputs can be accessed via ${data.terraform_remote_state.base.output_name}
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
