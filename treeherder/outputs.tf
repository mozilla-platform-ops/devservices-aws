output "heroku_rds" {
    value = "${aws_db_instance.treeherder-heroku.address}"
}
output "stage_rds" {
    value = "${aws_db_instance.treeherder-stage-rds.address}"
}
output "prod_rds" {
    value = "${aws_db_instance.treeherder-prod-rds.address}"
}
