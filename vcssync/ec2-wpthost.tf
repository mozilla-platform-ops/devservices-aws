resource "aws_security_group" "wpt_vcs_sync_testing" {
    name = "wpt_vcs_sync"
    description = "Access needed for WPT Sync Testing"

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
}

resource "aws_instance" "wpt_vcs_sync_testing" {
    ami = "${lookup(var.centos7_amis, "us-west-2")}"
    instance_type = "t2.medium"
    instance_initiated_shutdown_behavior = "terminate"

    iam_instance_profile = "${aws_iam_instance_profile.wpt-sync-testing.name}"
    user_data = "${file("files/jumphost-userdata.sh")}"

    key_name = "${var.key_name}"
    security_groups = ["${aws_security_group.wpt_vcs_sync_testing.name}"]

    root_block_device {
        volume_type = "gp2"
        volume_size = "40"
        delete_on_termination = true
    }

    tags {
        Name = "WPT VCS Sync Testing"
        App = "WPT VCS Sync"
        Env = "dev"
        Owner = "gps@mozilla.com"
        BugId = "1401644"
    }
}
