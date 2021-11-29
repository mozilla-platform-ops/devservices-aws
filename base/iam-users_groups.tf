#---[ unmanaged ]---
# test_iam_policy group
# ses-smtp-user.20150603-212413 user

#---[ admin ]---
resource "aws_iam_group" "admin-group" {
    name = "admin"
}
resource "aws_iam_group_membership" "admin-groupmem" {
    name = "admin-group-membership"
    group = "${aws_iam_group.admin-group.name}"
    users = [
        "${aws_iam_user.dhouse.name}",
        "${aws_iam_user.ajvb.name}",
    ]
}
resource "aws_iam_user" "dhouse" {
    name = "dhouse"
}
resource "aws_iam_user" "ajvb" {
    name = "ajvb"
}

#---[ misc accounts ]---
resource "aws_iam_user" "vcs-archive-access" {
    name = "vcs-archive-access"
}

#---[ vcssync ]---
resource "aws_iam_group" "vcssync-group" {
    name = "vcs-sync"
}
resource "aws_iam_group_membership" "vcssync-groupmem" {
    name = "vcssync-group-membership"
    group = "${aws_iam_group.vcssync-group.name}"
    users = [
        "${aws_iam_user.asingh.name}",
        "${aws_iam_user.vcssync-log-writer.name}",
        "${aws_iam_user.vcssync-logwriter-releng.name}"
    ]
}
resource "aws_iam_user" "asingh" {
    name = "asingh"
}
resource "aws_iam_user" "vcssync-log-writer" {
    name = "vcssync-log-writer"
}
resource "aws_iam_user" "vcssync-logwriter-releng" {
    name = "vcssync-logwriter-releng"
}
