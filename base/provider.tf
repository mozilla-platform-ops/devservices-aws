provider "aws" {
    region = "${var.region}"
    profile = "${var.profile}"
}
provider "aws" {
    alias = "eu-central-1"
    region = "eu-central-1"
    profile = "${var.profile}"
}
provider "aws" {
    alias = "us-east-1"
    region = "us-east-1"
    profile = "${var.profile}"
}
provider "aws" {
    alias = "us-east-2"
    region = "us-east-2"
    profile = "${var.profile}"
}
provider "aws" {
    alias = "us-west-1"
    region = "us-west-1"
    profile = "${var.profile}"
}
provider "aws" {
    alias = "us-west-2"
    region = "us-west-2"
    profile = "${var.profile}"
}
