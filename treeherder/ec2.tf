resource "aws_volume_attachment" "treeherder_att" {
    device_name = "/dev/sdg"
    volume_id = "${aws_ebs_volume.treeherder_ebs.id}"
    instance_id = "${aws_instance.admin.id}"
}
resource "aws_ebs_volume" "treeherder_ebs" {
    availability_zone = "us-east-1a"
    encrypted = false
    size = 50
    type = "gp2"
    tags {
        Name = "treeherder_db_import"
        BugID = "1176486"
    }
}
resource "aws_instance" "admin" {
    instance_type = "t2.large"
    ami = "ami-0f8bce65"
    key_name = "fubar"
    subnet_id = "${aws_subnet.treeherder-subnet-1a.id}"
    vpc_security_group_ids = ["${aws_security_group.treeherder_heroku-sg.id}"]
    associate_public_ip_address = "True"
    tags {
        Name = "treeherder db import host"
        BugID = "1176486"
    }
}
