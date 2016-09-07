# TODO?: add NetOps-created resources for SCL3-AWS VPN (bug 1239660):
# vpn-gateway vgw-248a654d
# customer-gateway cgw-eb806f82
# vpn-connection vpn-ba6671db
# done: route rtb-445e6020

resource "aws_vpc" "treeherder-vpc" {
    cidr_block = "10.191.3.0/24"
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
    cidr_block = "10.191.3.0/26"
    map_public_ip_on_launch = "False"
    tags {
        Name = "treeherder-subnet-1a"
        BugID = "1239660"
    }
}

resource "aws_subnet" "treeherder-subnet-1b" {
    vpc_id = "${aws_vpc.treeherder-vpc.id}"
    availability_zone = "us-east-1b"
    cidr_block = "10.191.3.64/26"
    map_public_ip_on_launch = "False"
    tags {
        Name = "treeherder-subnet-1b"
        BugID = "1239660"
    }
}

resource "aws_subnet" "treeherder-subnet-1d" {
    vpc_id = "${aws_vpc.treeherder-vpc.id}"
    availability_zone = "us-east-1d"
    cidr_block = "10.191.3.128/26"
    map_public_ip_on_launch = "False"
    tags {
        Name = "treeherder-subnet-1d"
        BugID = "1239660"
    }
}

resource "aws_subnet" "treeherder-subnet-1e" {
    vpc_id = "${aws_vpc.treeherder-vpc.id}"
    availability_zone = "us-east-1e"
    cidr_block = "10.191.3.192/26"
    map_public_ip_on_launch = "False"
    tags {
        Name = "treeherder-subnet-1e"
        BugID = "1239660"
    }
}
