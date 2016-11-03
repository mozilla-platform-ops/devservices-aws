resource "aws_iam_user" "cdawson" {
    name = "cdawson"
}

resource "aws_iam_user" "emorley" {
    name = "emorley"
}

resource "aws_iam_user" "jgraham" {
    name = "jgraham"
}

resource "aws_iam_user" "wlachance" {
    name = "wlachance"
}

resource "aws_iam_group" "treeherder_rds_access-group" {
    name = "treeherder_rds_access-group"
}

resource "aws_iam_group_membership" "treeherder_rds_access-groupmem" {
    name = "treeherder_rds_access-group-membership"
    group = "${aws_iam_group.treeherder_rds_access-group.name}"
    users = [
        "${aws_iam_user.cdawson.name}",
        "${aws_iam_user.emorley.name}",
        "${aws_iam_user.jgraham.name}",
        "${aws_iam_user.wlachance.name}"
    ]
}
