# NOTE:
# Region specific resources make use of a "provider alias" to override the base setting

#---[ US-EAST-1 ]---
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
        Name = "jumphost-external-sg"
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
        Name = "jumphost-internal-sg"
    }
}

#---[ US-WEST-1 ]---

#---[ US-WEST-2 ]---
resource "aws_security_group" "jumphost_usw2_sg" {
    provider = "aws.us-west-2"
    name_prefix = "jumphost_usw2_sg-"
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
        Name = "jumphost-external-sg"
    }
}

resource "aws_security_group" "jumphost_internal_usw2_sg" {
    provider = "aws.us-west-2"
    name = "jumphost_internal_sg"
    description = "Allow all access from jumphost"
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        security_groups = ["${aws_security_group.jumphost_usw2_sg.id}"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        security_groups = ["${aws_security_group.jumphost_usw2_sg.id}"]
    }
    tags {
        Name = "jumphost-internal-sg"
    }
}
