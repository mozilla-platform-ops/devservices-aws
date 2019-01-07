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
        use1_default = "172.31.0.0/16"
        usw2_default = "172.31.0.0/16"
        treeherder-vpc = "10.191.3.0/24"
    }
}

variable "user_data_scripts" {
    description = "List of user-data scripts to manage in S3 bucket"
    default = "associate-eip,attach-vol,set_sysctl"
    # ssh-pubkeys.tmpl handled via template_file resource in base/s3.tf
}

variable "pubkey_bucket_prefix" {
    description = "S3 bucket prefix for pubkeys in base_bucket"
    default = "pubkeys"
}

variable "ssh_key_names" {
    description = "List of SSH pub keys to manage in S3 bucket"
    default = "hwine1,klibby2,bjones,jwatkins1,smacleod1"
}
