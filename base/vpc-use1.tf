# NOTE:
# Region specific resources make use of a "provider alias" to override the base setting

#---[ US-EAST-1 ]---
resource "aws_vpc" "use1_default-vpc" {
    provider = "aws.us-east-1"
    cidr_block = "${var.vpc_map["use1_default"]}"
    tags {
        Name = "base-default-vpc"
        App = "base"
        Env = "default"
        Type = "vpc"
        Owner = "relops"
    }
}

resource "aws_subnet" "jumphost_use1_subnet" {
    provider = "aws.us-east-1"
    vpc_id = "${aws_vpc.use1_default-vpc.id}"
    availability_zone = "us-east-1a"
    cidr_block = "172.31.254.0/24"
    map_public_ip_on_launch = true
    tags {
        Name = "base-bastion-subnet"
        App = "base"
        Env = "bastion"
        Type = "subnet"
        Owner = "relops"
    }
}

resource "aws_security_group" "jumphost_use1_sg" {
    provider = "aws.us-east-1"
    name_prefix = "jumphost_use1_sg-"
    description = "Allow SSH to jumphost from all"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    lifecycle {
        create_before_destroy = true
    }
    tags {
        Name = "base-bastion-external_sg"
        App = "base"
        Env = "bastion"
        Type = "external_sg"
        Owner = "relops"
    }
}
resource "aws_security_group" "jumphost_internal_use1_sg" {
    provider = "aws.us-east-1"
    name = "jumphost_internal_sg"
    description = "Allow all access from jumphost"
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        security_groups = ["${aws_security_group.jumphost_use1_sg.id}"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        security_groups = ["${aws_security_group.jumphost_use1_sg.id}"]
    }
    tags {
        Name = "base-bastion-internal_sg"
        App = "base"
        Env = "bastion"
        Type = "internal_sg"
        Owner = "relops"
    }
}
