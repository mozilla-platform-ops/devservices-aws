# pre-existing roles
#   ec-read-tags
#   vcssync-log-writer
#   moz-hg-bundle-moz-hg-bundle-2-s3-repl-role
# InfoSec roles
#   DeployCloudTrailCloudFormation-LambdaExecutionRole-1Q5F6FCE5W9EX
#   InfosecClientRoles-InfosecIncidentResponseRole-RD01D6B40TA
#   InfosecClientRoles-InfosecSecurityAuditRole-1ADWA19UKD683
#   InfosecClientRoles-LambdaExecutionRole-1HSROHAMR9Z1Z

# EC2 role to read SSH public keys s3 bucket
resource "aws_iam_instance_profile" "ec2-read-ssh-keys" {
    name = "ec2-read-ssh-keys"
    role = "${aws_iam_role.ec2-assume-role.name}"
}
resource "aws_iam_role" "ec2-assume-role" {
    name = "ec2-assume-role"
    assume_role_policy = "${file("files/ec2-assume-role.json")}"
}
resource "aws_iam_role_policy" "ec2-read-s3-keys" {
    name = "ec2-read-s3-keys"
    role = "${aws_iam_role.ec2-assume-role.id}"
    policy = "${file("files/ec2-read-s3-keys.json")}"
}

# Allow bastion hosts to AssumeRole
resource "aws_iam_role" "ec2_manage_eip-role" {
    name = "ec2_manage_eip"
    assume_role_policy = "${file("files/ec2-assume-role.json")}"
}

# Allow bastion hosts to manage their Elastic IP
resource "aws_iam_role_policy" "ec2_manage_eip-policy" {
    name = "ec2_manage_eip-policy"
    role = "${aws_iam_role.ec2_manage_eip-role.id}"
    policy = "${file("files/ec2-manage-EIP.json")}"
}

# Create instance profile for bastion hosts to manage EIP
resource "aws_iam_instance_profile" "ec2_manage_eip-profile" {
    name = "ec2_manage_eip"
    role = "${aws_iam_role.ec2_manage_eip-role.name}"
}

# RDS role to send enhanced monitoring to CloudWatch
# http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_Monitoring.html
resource "aws_iam_role" "rds-monitoring-role" {
    name = "rds-monitoring-role"
    assume_role_policy = "${file("files/rds-assume-role.json")}"
}
resource "aws_iam_policy_attachment" "rds_to_cloudwatch-attach" {
    name = "rds_to_cloudwatch-attach"
    roles = ["${aws_iam_role.rds-monitoring-role.name}"]
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}
