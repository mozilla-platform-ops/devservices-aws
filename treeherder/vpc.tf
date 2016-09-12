# NetOps-created resources for SCL3-AWS VPN (bug 1239660):
resource "aws_vpn_gateway" "take-me-to-SCL3" {
    vpc_id = "${aws_vpc.treeherder-vpc.id}"
    tags {
        Name = "take-me-to-SCL3"
    }
}
resource "aws_customer_gateway" "fw1_scl3_mozilla_net" {
    type = "ipsec.1"
    bgp_asn = "65022"
    ip_address = "63.245.214.100"
    tags {
        Name = "fw1_scl3_mozilla_net"
    }
}
resource "aws_vpn_connection" "to-scl3" {
    vpn_gateway_id = "${aws_vpn_gateway.take-me-to-SCL3.id}"
    customer_gateway_id = "${aws_customer_gateway.fw1_scl3_mozilla_net.id}"
    type = "ipsec.1"
    static_routes_only = ""
    tags {
        Name = "to-scl3"
    }
}

# original sg for treeherder-heroku rds, in default vpc
resource "aws_security_group" "treeherder_heroku_sg" {
    name = "treeherder_heroku_sg"
    description = "Treeherder Heroku RDS access"
    vpc_id = "vpc-ccf5aca9"
    tags {
        Name = "treeherder_heroku_sg"
    }
}
resource "aws_security_group_rule" "treeherder_heroku_sg" {
    type = "ingress"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.treeherder_heroku_sg.id}"
}
resource "aws_security_group_rule" "treeherder_heroku_sg-1" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.treeherder_heroku_sg.id}"
}

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

resource "aws_vpc" "treeherder-vpc" {
    cidr_block = "${var.vpc_map["treeherder-vpc"]}"
    enable_dns_support = "True"
    enable_dns_hostnames = "True"
    tags {
        Name = "treeherder-vpc"
        BugID = "1239660"
    }
}

resource "aws_internet_gateway" "treeherder-gw" {
    vpc_id = "${aws_vpc.treeherder-vpc.id}"
    tags {
        Name = "treeherder-gw"
        BugID = "1239660"
    }
}

# "imported" rtb-445e6020 from manual setup
resource "aws_route_table" "treeherder-rt" {
    vpc_id = "${aws_vpc.treeherder-vpc.id}"
    route {
        cidr_block = "10.0.0.0/10"
        gateway_id = "vgw-248a654d"
    }
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.treeherder-gw.id}"
    }
    tags {
        Name = "treeherder-rt"
        BugID = "1239660"
    }
}

# add Name tag to display in console
resource "aws_subnet" "treeherder-subnet-1a" {
    vpc_id = "${aws_vpc.treeherder-vpc.id}"
    availability_zone = "us-east-1a"
    cidr_block = "${cidrsubnet("${var.vpc_map["treeherder-vpc"]}", 2, 0)}"
    map_public_ip_on_launch = "False"
    tags {
        Name = "treeherder-subnet-1a"
        BugID = "1239660"
    }
}

resource "aws_subnet" "treeherder-subnet-1b" {
    vpc_id = "${aws_vpc.treeherder-vpc.id}"
    availability_zone = "us-east-1b"
    cidr_block = "${cidrsubnet("${var.vpc_map["treeherder-vpc"]}", 2, 1)}"
    map_public_ip_on_launch = "False"
    tags {
        Name = "treeherder-subnet-1b"
        BugID = "1239660"
    }
}

resource "aws_subnet" "treeherder-subnet-1d" {
    vpc_id = "${aws_vpc.treeherder-vpc.id}"
    availability_zone = "us-east-1d"
    cidr_block = "${cidrsubnet("${var.vpc_map["treeherder-vpc"]}", 2, 2)}"
    map_public_ip_on_launch = "False"
    tags {
        Name = "treeherder-subnet-1d"
        BugID = "1239660"
    }
}

resource "aws_subnet" "treeherder-subnet-1e" {
    vpc_id = "${aws_vpc.treeherder-vpc.id}"
    availability_zone = "us-east-1e"
    cidr_block = "${cidrsubnet("${var.vpc_map["treeherder-vpc"]}", 2, 3)}"
    map_public_ip_on_launch = "False"
    tags {
        Name = "treeherder-subnet-1e"
        BugID = "1239660"
    }
}
