resource "aws_security_group" "treeherder_heroku-sg" {
    name = "treeherder_heroku-sg"
    description = "Treeherder Heroku RDS access"
    vpc_id = "${aws_vpc.treeherder-vpc.id}"
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
        Name = "treeherder-prod-sg"
        App = "treeherder"
        Type = "sg"
        Env = "prod"
        Owner = "relops"
        BugID = "1176486"
    }
}

resource "aws_vpc" "treeherder-vpc" {
    cidr_block = "${var.vpc_map["treeherder-vpc"]}"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags {
        Name = "treeherder-prod-vpc"
        App = "treeherder"
        Type = "vpc"
        Env = "prod"
        Owner = "relops"
        BugID = "1239660"
    }
}

resource "aws_internet_gateway" "treeherder-gw" {
    vpc_id = "${aws_vpc.treeherder-vpc.id}"
    tags {
        Name = "treeherder-prod-igw"
        App = "treeherder"
        Type = "igw"
        Env = "prod"
        Owner = "relops"
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
        Name = "treeherder-prod-rt"
        App = "treeherder"
        Type = "rt"
        Env = "prod"
        Owner = "relops"
        BugID = "1239660"
    }
}

# add Name tag to display in console
resource "aws_subnet" "treeherder-subnet-1a" {
    vpc_id = "${aws_vpc.treeherder-vpc.id}"
    availability_zone = "us-east-1a"
    cidr_block = "${cidrsubnet("${var.vpc_map["treeherder-vpc"]}", 2, 0)}"
    map_public_ip_on_launch = false
    tags {
        Name = "treeherder-prod-subnet-1a"
        App = "treeherder"
        Type = "subnet"
        Env = "prod"
        Owner = "relops"
        BugID = "1239660"
    }
}

resource "aws_subnet" "treeherder-subnet-1b" {
    vpc_id = "${aws_vpc.treeherder-vpc.id}"
    availability_zone = "us-east-1b"
    cidr_block = "${cidrsubnet("${var.vpc_map["treeherder-vpc"]}", 2, 1)}"
    map_public_ip_on_launch = false
    tags {
        Name = "treeherder-prod-subnet-1b"
        App = "treeherder"
        Type = "subnet"
        Env = "prod"
        Owner = "relops"
        BugID = "1239660"
    }
}

resource "aws_subnet" "treeherder-subnet-1d" {
    vpc_id = "${aws_vpc.treeherder-vpc.id}"
    availability_zone = "us-east-1d"
    cidr_block = "${cidrsubnet("${var.vpc_map["treeherder-vpc"]}", 2, 2)}"
    map_public_ip_on_launch = false
    tags {
        Name = "treeherder-prod-subnet-1d"
        App = "treeherder"
        Type = "subnet"
        Env = "prod"
        Owner = "relops"
        BugID = "1239660"
    }
}

resource "aws_subnet" "treeherder-subnet-1e" {
    vpc_id = "${aws_vpc.treeherder-vpc.id}"
    availability_zone = "us-east-1e"
    cidr_block = "${cidrsubnet("${var.vpc_map["treeherder-vpc"]}", 2, 3)}"
    map_public_ip_on_launch = false
    tags {
        Name = "treeherder-prod-subnet-1e"
        App = "treeherder"
        Type = "subnet"
        Env = "prod"
        Owner = "relops"
        BugID = "1239660"
    }
}
