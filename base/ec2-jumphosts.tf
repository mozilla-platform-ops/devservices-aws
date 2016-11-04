# NOTE:
# Region specific resources make use of a "provider alias" to override the base setting

#---[ US-EAST-1 ]---
resource "aws_launch_configuration" "jumphost_use1_lc" {
    provider = "aws.us-east-1"
    name_prefix = "jumphost_use1_lc-"
    instance_type = "t2.micro"
    image_id = "${lookup(var.centos7_amis,"us-east-1")}"
    key_name = "${var.key_name}"
    security_groups = ["${aws_security_group.jumphost_use1_sg.name}"]
    iam_instance_profile = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:instance-profile/ec2-read-ssh-keys"
    user_data = "${file("files/jumphost-userdata.sh")}"
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "jumphost_use1_asg" {
    provider = "aws.us-east-1"
    name = "jumphost-asg"
    vpc_zone_identifier = ["${aws_subnet.jumphost_use1_subnet.id}"]
    max_size = 2
    min_size = 1
    #force_delete = true
    launch_configuration = "${aws_launch_configuration.jumphost_use1_lc.name}"
    lifecycle {
        create_before_destroy = true
    }
    tag {
        key = "Name"
        value = "base-bastion-jumphost"
        propagate_at_launch = true
    }
    tag {
        key = "App"
        value = "base"
        propagate_at_launch = true
    }
    tag {
        key = "Env"
        value = "bastion"
        propagate_at_launch = true
    }
    tag {
        key = "Type"
        value = "jumphost"
        propagate_at_launch = true
    }
    tag {
        key = "Owner"
        value = "relops"
        propagate_at_launch = true
    }
}

#---[ US-WEST-1 ]---
#---[ US-WEST-2 ]---
resource "aws_launch_configuration" "jumphost_usw2_lc" {
    provider = "aws.us-west-2"
    name_prefix = "jumphost_usw2_lc-"
    instance_type = "t2.micro"
    image_id = "${lookup(var.centos7_amis,"us-west-2")}"
    key_name = "${var.key_name}"
    security_groups = ["${aws_security_group.jumphost_usw2_sg.name}"]
    iam_instance_profile = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:instance-profile/ec2-read-ssh-keys"
    user_data = "${file("files/jumphost-userdata.sh")}"
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "jumphost_usw2_asg" {
    provider = "aws.us-west-2"
    name = "jumphost-asg"
    vpc_zone_identifier = ["${aws_subnet.jumphost_usw2_subnet.id}"]
    max_size = 2
    min_size = 1
    #force_delete = true
    launch_configuration = "${aws_launch_configuration.jumphost_usw2_lc.name}"
    lifecycle {
        create_before_destroy = true
    }
    tag {
        key = "Name"
        value = "base-bastion-jumphost"
        propagate_at_launch = true
    }
    tag {
        key = "App"
        value = "base"
        propagate_at_launch = true
    }
    tag {
        key = "Env"
        value = "bastion"
        propagate_at_launch = true
    }
    tag {
        key = "Type"
        value = "jumphost"
        propagate_at_launch = true
    }
    tag {
        key = "Owner"
        value = "relops"
        propagate_at_launch = true
    }
}
