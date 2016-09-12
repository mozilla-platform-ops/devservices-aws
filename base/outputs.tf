output "use1_default_vpc_id" {
    value = "${aws_vpc.use1_default-vpc.id}"
}
output "usw2_default_vpc_id" {
    value = "${aws_vpc.usw2_default-vpc.id}"
}
output "allow_use1_jumphost_sg_id" {
    value = "${aws_security_group.jumphost_use1_sg.id}"
}
output "allow_usw2_jumphost_sg_id" {
    value = "${aws_security_group.jumphost_usw2_sg.id}"
}
