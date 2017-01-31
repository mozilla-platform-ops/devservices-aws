# coordinate name change with aws_iam_policy_document.treeherder_rds in iam.tf
resource "aws_db_subnet_group" "treeherder-dbgrp" {
    name = "treeherder-dbgrp"
    description = "Treeherder DB subnet group"
    subnet_ids = ["${aws_subnet.treeherder-subnet-1a.id}",
                  "${aws_subnet.treeherder-subnet-1b.id}",
                  "${aws_subnet.treeherder-subnet-1d.id}",
                  "${aws_subnet.treeherder-subnet-1e.id}"]
    tags {
        Name = "treeherder-prod-dbgrp"
        App = "treeherder"
        Type = "dbgrp"
        Env = "prod"
        Owner = "relops"
        BugID = "1176486"
    }
}

# coordinate name change with aws_iam_policy_document.treeherder_rds in iam.tf
resource "aws_db_parameter_group" "treeherder-pg" {
    name = "treeherder"
    family = "mysql5.6"
    description = "Main Treeherder parameter group"
    parameter {
        name = "character_set_server"
        value = "utf8"
    }
    parameter {
        name = "collation_server"
        value = "utf8_bin"
    }
    parameter {
        name = "log_output"
        value = "FILE"
    }
    parameter {
        name = "long_query_time"
        value = "2"
    }
    parameter {
        name = "slow_query_log"
        value = "1"
    }
    parameter {
        name = "sql_mode"
        value = "NO_ENGINE_SUBSTITUTION,STRICT_ALL_TABLES"
    }
    tags {
        Name = "treeherder-prod-pg"
        App = "treeherder"
        Type = "pg"
        Env = "prod"
        Owner = "relops"
    }
}

resource "aws_db_instance" "treeherder-dev-rds" {
    identifier = "treeherder-dev"
    snapshot_identifier = "rds:treeherder-prod-2017-01-24-07-06"
    storage_type = "gp2"
    engine = "mysql"
    engine_version = "5.6.34"
    instance_class = "db.m4.xlarge"
    maintenance_window = "Sun:08:00-Sun:08:30"
    multi_az = false
    port = "3306"
    publicly_accessible = true
    parameter_group_name = "treeherder"
    auto_minor_version_upgrade = false
    db_subnet_group_name = "${aws_db_subnet_group.treeherder-dbgrp.name}"
    vpc_security_group_ids = ["${aws_security_group.treeherder_heroku-sg.id}"]
    tags {
        Name = "treeherder-dev-rds"
        App = "treeherder"
        Type = "rds"
        Env = "dev"
        Owner = "relops"
        BugID = "1309395"
    }
}

resource "aws_db_instance" "treeherder-stage-rds" {
    identifier = "treeherder-stage"
    storage_type = "gp2"
    allocated_storage = 750
    engine = "mysql"
    engine_version = "5.6.34"
    instance_class = "db.m4.xlarge"
    username = "th_admin"
    password = "XXXXXXXXXXXXXXXX"
    backup_retention_period = 1
    backup_window = "07:00-07:30"
    maintenance_window = "Sun:08:00-Sun:08:30"
    multi_az = true
    port = "3306"
    publicly_accessible = true
    parameter_group_name = "treeherder"
    auto_minor_version_upgrade = false
    db_subnet_group_name = "${aws_db_subnet_group.treeherder-dbgrp.name}"
    vpc_security_group_ids = ["${aws_security_group.treeherder_heroku-sg.id}"]
    monitoring_role_arn = "arn:aws:iam::699292812394:role/rds-monitoring-role"
    monitoring_interval = 60
    tags {
        Name = "treeherder-stage-rds"
        App = "treeherder"
        Type = "rds"
        Env = "stage"
        Owner = "relops"
        BugID = "1176486"
    }
}

resource "aws_db_instance" "treeherder-prod-rds" {
    identifier = "treeherder-prod"
    storage_type = "gp2"
    allocated_storage = 750
    engine = "mysql"
    engine_version = "5.6.34"
    instance_class = "db.m4.2xlarge"
    username = "th_admin"
    password = "XXXXXXXXXXXXXXXX"
    backup_retention_period = 1
    backup_window = "07:00-07:30"
    maintenance_window = "Sun:08:00-Sun:08:30"
    multi_az = true
    port = "3306"
    publicly_accessible = true
    parameter_group_name = "treeherder"
    auto_minor_version_upgrade = false
    db_subnet_group_name = "${aws_db_subnet_group.treeherder-dbgrp.name}"
    vpc_security_group_ids = ["${aws_security_group.treeherder_heroku-sg.id}"]
    monitoring_role_arn = "arn:aws:iam::699292812394:role/rds-monitoring-role"
    monitoring_interval = 60
    tags {
        Name = "treeherder-prod-rds"
        App = "treeherder"
        Type = "rds"
        Env = "prod"
        Owner = "relops"
        BugID = "1276307"
    }
}

resource "aws_db_instance" "treeherder-prod-ro-rds" {
    identifier = "treeherder-prod-ro"
    replicate_source_db = "${aws_db_instance.treeherder-prod-rds.id}"
    storage_type = "gp2"
    engine = "mysql"
    engine_version = "5.6.34"
    instance_class = "db.m4.xlarge"
    maintenance_window = "Sun:08:00-Sun:08:30"
    multi_az = false
    port = "3306"
    publicly_accessible = true
    parameter_group_name = "treeherder"
    auto_minor_version_upgrade = false
    vpc_security_group_ids = ["${aws_security_group.treeherder_heroku-sg.id}"]
    monitoring_role_arn = "arn:aws:iam::699292812394:role/rds-monitoring-role"
    monitoring_interval = 60
    tags {
        Name = "treeherder-prod-ro-rds"
        App = "treeherder"
        Type = "rds"
        Env = "prod-ro"
        Owner = "relops"
        BugID = "1311468"
    }
}
