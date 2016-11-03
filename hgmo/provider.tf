provider "aws" {
    region = "${var.region}"
    profile = "${var.profile}"
}

provider "aws" {
    alias = "use1"
    region = "us-east-1"
}

provider "aws" {
    alias = "usw1"
    region = "us-west-1"
}

provider "aws" {
    alias = "usw2"
    region = "us-west-2"
}

provider "aws" {
    alias = "euc1"
    region = "eu-central-1"
}
