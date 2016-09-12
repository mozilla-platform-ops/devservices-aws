variable "base_bucket" {
    description = "S3 bucket for storing terraform state, ssh pub keys, etc"
    default = "moz-devservices"
}

variable "logging_bucket" {
    description = "S3 bucket for activity logging"
    default = "moz-devservices-logging"
}

variable "centos7_amis" {
    description = "Centos 7 (x86_64) with Updates HVM, rel 02/26/2016"
    type = "map"
    default = {
        us-east-1 = "ami-6d1c2007"
        us-west-1 = "ami-af4333cf"
        us-west-2 = "ami-d2c924b2"
    }
}

variable "vpc_map" {
    description = "Map of VPCs and CIDR blocks"
    type = "map"
    default = {
        treeherder-vpc = "10.191.3.0/24"
    }
}
