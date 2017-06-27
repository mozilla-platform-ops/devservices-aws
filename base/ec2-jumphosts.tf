# NOTE:
# Region specific resources make use of a "provider alias" to override the base setting

data "template_file" "jh_user_data" {
    template = "${file("files/user_data.tmpl")}"
    vars {
        s3_bucket = "${var.base_bucket}"
        addl_user_data = "ssh-pubkeys,associate-eip,set_sysctl"
    }
}

#---[ US-EAST-1 ]---
resource "aws_eip" "jumphost_use1_eip" {
    provider = "aws.us-east-1"
    vpc = true
}

resource "aws_launch_configuration" "jumphost_use1_lc" {
    provider = "aws.us-east-1"
    name_prefix = "jumphost_use1_lc-"
    instance_type = "t2.micro"
    image_id = "${lookup(var.centos7_amis,"us-east-1")}"
    key_name = "${var.key_name}"
    security_groups = ["${aws_security_group.jumphost_use1_sg.id}"]
    iam_instance_profile = "${aws_iam_instance_profile.ec2_manage_eip-profile.arn}"
    user_data = "${data.template_file.jh_user_data.rendered}"
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
    tag {
        key = "EIP"
        value = "${aws_eip.jumphost_use1_eip.public_ip}"
        propagate_at_launch = true
    }
}

#---[ US-WEST-1 ]---
#---[ US-WEST-2 ]---
resource "aws_eip" "jumphost_usw2_eip" {
    provider = "aws.us-west-2"
    vpc = true
}

resource "aws_launch_configuration" "jumphost_usw2_lc" {
    provider = "aws.us-west-2"
    name_prefix = "jumphost_usw2_lc-"
    instance_type = "t2.micro"
    image_id = "${lookup(var.centos7_amis,"us-west-2")}"
    key_name = "${var.key_name}"
    security_groups = ["${aws_security_group.jumphost_usw2_sg.id}"]
    iam_instance_profile = "${aws_iam_instance_profile.ec2_manage_eip-profile.arn}"
    user_data = "${data.template_file.jh_user_data.rendered}"
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
    tag {
        key = "EIP"
        value = "${aws_eip.jumphost_usw2_eip.public_ip}"
        propagate_at_launch = true
    }
}
