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
        "${aws_iam_user.fubar.name}",
        "${aws_iam_user.gps.name}",
        "${aws_iam_user.hwine.name}"
    ]
}
resource "aws_iam_user" "fubar" {
    name = "fubar"
}
resource "aws_iam_user" "gps" {
    name = "gps"
}
resource "aws_iam_user" "hwine" {
    name = "hwine"
}

#---[ misc accounts ]---
resource "aws_iam_user" "hgbundler" {
    name = "hgbundler"
}
resource "aws_iam_user" "vcs-archive-access" {
    name = "vcs-archive-access"
}

#---[ BMO devs ]---
resource "aws_iam_group" "bmodevs-group" {
    name = "bmo_devs"
}
resource "aws_iam_group_membership" "bmodev-groupmem" {
    name = "bmodev-group-membership"
    group = "${aws_iam_group.bmodevs-group.name}"
    users = [
        "${aws_iam_user.dkl.name}",
        "${aws_iam_user.dylan.name}",
        "${aws_iam_user.glob.name}"
    ]
}
resource "aws_iam_user" "dkl" {
    name = "dkl"
}
resource "aws_iam_user" "dylan" {
    name = "dylan"
}
resource "aws_iam_user" "glob" {
    name = "glob"
}

#---[ Netops users ]---
resource "aws_iam_group" "netops-group" {
    name = "netops"
}
resource "aws_iam_group_membership" "netops-groupmem" {
    name = "netops-group-membership"
    group = "${aws_iam_group.netops-group.name}"
    users = [
        "${aws_iam_user.dcurado.name}",
        "${aws_iam_user.xionix.name}"
    ]
}
resource "aws_iam_user" "dcurado" {
    name = "dcurado"
}
resource "aws_iam_user" "xionix" {
    name = "xionix"
}

#---[ Treeherder devs ]---
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

#---[ vcssync ]---
resource "aws_iam_group" "vcssync-group" {
    name = "vcs-sync"
}
resource "aws_iam_group_membership" "vcssync-groupmem" {
    name = "vcssync-group-membership"
    group = "${aws_iam_group.vcssync-group.name}"
    users = [
        "${aws_iam_user.asingh.name}",
        "${aws_iam_user.hwine.name}",
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
