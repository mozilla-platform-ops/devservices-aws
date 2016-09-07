resource "aws_security_group" "treeherder_heroku-sg" {
    name = "treeherder_heroku-sg"
    description = "Treeherder Heroku RDS access"
    vpc_id = "${aws_vpc.treeherder-vpc.id}"
    ingress {
        from_port = 8
        to_port = "-1"
        protocol = "icmp"
        cidr_blocks = ["10.0.0.0/8"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
        Name = "treeherder_heroku-sg"
        BugID = "1176486"
    }
}
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
