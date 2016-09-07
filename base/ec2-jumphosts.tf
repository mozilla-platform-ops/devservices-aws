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
resource "aws_launch_configuration" "jumphost_use1_lc" {
    provider = "aws.us-east-1"
    name_prefix = "jumphost_use1_lc-"
    instance_type = "t2.micro"
    image_id = "${lookup(var.centos7_amis,"us-east-1")}"
    key_name = "${var.key_name}"
    security_groups = ["${aws_security_group.jumphost_use1_sg.name}"]
    iam_instance_profile = "arn:aws:iam::699292812394:instance-profile/ec2-read-ssh-keys"
    user_data = "${file("files/jumphost-userdata.sh")}"
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "jumphost_use1_asg" {
    provider = "aws.us-east-1"
    name = "jumphost-asg"
    availability_zones = ["us-east-1a"]
    max_size = 2
    min_size = 1
    #force_delete = true
    launch_configuration = "${aws_launch_configuration.jumphost_use1_lc.name}"
    lifecycle {
        create_before_destroy = true
    }
    tag {
        key = "Name"
        value = "jumphost"
        propagate_at_launch = true
    }
    tag {
        key = "Type"
        value = "autoscale instance"
        propagate_at_launch = true
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
# NB: can't query region when using provider aliases, so specify it manually
resource "aws_launch_configuration" "jumphost_usw2_lc" {
    provider = "aws.us-west-2"
    name_prefix = "jumphost_usw2_lc-"
    instance_type = "t2.micro"
    image_id = "${lookup(var.centos7_amis,"us-west-2")}"
    key_name = "${var.key_name}"
    security_groups = ["${aws_security_group.jumphost_usw2_sg.name}"]
    iam_instance_profile = "arn:aws:iam::699292812394:instance-profile/ec2-read-ssh-keys"
    user_data = "${file("files/jumphost-userdata.sh")}"
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "jumphost_usw2_asg" {
    provider = "aws.us-west-2"
    name = "jumphost-asg"
    availability_zones = ["us-west-2a"]
    max_size = 2
    min_size = 1
    #force_delete = true
    launch_configuration = "${aws_launch_configuration.jumphost_usw2_lc.name}"
    lifecycle {
        create_before_destroy = true
    }
    tag {
        key = "Name"
        value = "jumphost"
        propagate_at_launch = true
    }
    tag {
        key = "Type"
        value = "autoscale instance"
        propagate_at_launch = true
    }
}
