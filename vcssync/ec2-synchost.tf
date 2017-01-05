resource "aws_security_group" "servo_vcs_sync" {
  name = "servo_vcs_sync"
  description = "Access needed by Servo VCS Syncing"

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      security_groups = ["${data.terraform_remote_state.base.allow_usw2_jumphost_sg_id}"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "servo_vcs_sync" {
    ami = "${lookup(var.centos7_amis, "us-west-2")}"
    instance_type = "t2.medium"
    instance_initiated_shutdown_behavior = "stop"

    iam_instance_profile = "${aws_iam_instance_profile.servo.name}"
    user_data = "${file("files/jumphost-userdata.sh")}"

    key_name = "${var.key_name}"
    security_groups = ["${aws_security_group.servo_vcs_sync.name}"]

    root_block_device {
        volume_type = "gp2"
        volume_size = "40"
        delete_on_termination = true
    }

    tags {
        Name = "Servo VCS Sync"
        App = "VCS Sync"
        Env = "prod"
        Owner = "gps@mozilla.com"
        Bugid = "1317525"
    }
}
