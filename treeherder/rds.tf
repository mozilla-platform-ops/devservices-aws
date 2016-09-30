resource "aws_db_subnet_group" "treeherder-dbgrp" {
    name = "treeherder-dbgrp"
    description = "Treeherder DB subnet group"
    subnet_ids = ["${aws_subnet.treeherder-subnet-1a.id}",
                  "${aws_subnet.treeherder-subnet-1b.id}",
                  "${aws_subnet.treeherder-subnet-1d.id}",
                  "${aws_subnet.treeherder-subnet-1e.id}"]
    tags {
        Name = "treeherder-dbgrp"
        BugID = "1176486"
    }
}

resource "aws_db_parameter_group" "th_import-pg" {
    name = "th-import"
    family = "mysql5.6"
    description = "Pre-replication DB import param group"
    parameter {
        name = "autocommit"
        value = "1"
    }
    parameter {
        name = "character_set_server"
        value = "utf8"
    }
    parameter {
        name = "collation_server"
        value = "utf8_bin"
    }
    parameter {
        name = "ft_min_word_len"
        value = "2"
        apply_method = "pending-reboot"
    }
    # default; comment out to prevent constant re-apply issues
    #parameter {
    #    name = "innodb_file_per_table"
    #    value = "1"
    #}
    parameter {
        name = "innodb_flush_log_at_trx_commit"
        value = "0"
    }
    parameter {
        name = "innodb_log_buffer_size"
        value = "67108864"
        apply_method = "pending-reboot"
    }
    parameter {
        name = "max_allowed_packet"
        value = "134217728"
    }
    # default; comment out to prevent constant re-apply issues
    #parameter {
    #    name = "performance_schema"
    #    value = "0"
    #    apply_method = "pending-reboot"
    #}
    parameter {
        name = "slow_query_log"
        value = "0"
    }
    parameter {
        name = "sync_binlog"
        value = "0"
    }
}

resource "aws_db_parameter_group" "th_replication-pg" {
    name = "th-replication"
    family = "mysql5.6"
    description = "Replication param group"
    parameter {
        name = "character_set_server"
        value = "utf8"
    }
    parameter {
        name = "collation_server"
        value = "utf8_bin"
    }
    parameter {
        name = "ft_min_word_len"
        value = "2"
        apply_method = "pending-reboot"
    }
    parameter {
        name = "innodb_buffer_pool_dump_at_shutdown"
        value = "1"
    }
    parameter {
        name = "innodb_buffer_pool_load_at_startup"
        value = "1"
        apply_method = "pending-reboot"
    }
    parameter {
        name = "innodb_flush_log_at_trx_commit"
        value = "2"
    }
    parameter {
        name = "innodb_lock_wait_timeout"
        value = "50"
    }
    parameter {
        name = "innodb_log_buffer_size"
        value = "52428800"
        apply_method = "pending-reboot"
    }
    parameter {
        name = "interactive_timeout"
        value = "600"
    }
    parameter {
        name = "join_buffer_size"
        value = "8388608"
    }
    parameter {
        name = "long_query_time"
        value = "2"
    }
    parameter {
        name = "max_allowed_packet"
        value = "33554432"
    }
    parameter {
        name = "net_buffer_length"
        value = "32768"
    }
    parameter {
        name = "preload_buffer_size"
        value = "2097152"
    }
    parameter {
        name = "query_cache_size"
        value = "0"
    }
    parameter {
        name = "query_cache_type"
        value = "0"
        apply_method = "pending-reboot"
    }
    parameter {
        name = "read_buffer_size"
        value = "8388608"
    }
    parameter {
        name = "read_only"
        value = "1"
    }
    parameter {
        name = "read_rnd_buffer_size"
        value = "4194304"
    }
    parameter {
        name = "skip_name_resolve"
        value = "1"
        apply_method = "pending-reboot"
    }
    parameter {
        name = "slow_query_log"
        value = "1"
    }
    parameter {
        name = "table_open_cache"
        value = "3072"
    }
    parameter {
        name = "thread_cache_size"
        value = "500"
    }
    parameter {
        name = "tmp_table_size"
        value = "33554432"
    }
    parameter {
        name = "wait_timeout"
        value = "6000"
    }
    parameter {
        name = "sync_binlog"
        value = "0"
    }
}

resource "aws_db_instance" "treeherder-heroku" {
    identifier = "treeherder-heroku"
    storage_type = "gp2"
    allocated_storage = 500
    engine = "mysql"
    engine_version = "5.6.29"
    instance_class = "db.m4.xlarge"
    username = "th_admin"
    backup_retention_period = 1
    backup_window = "07:00-07:30"
    maintenance_window = "Sun:08:00-Sun:08:30"
    multi_az = true
    port = "3306"
    publicly_accessible = true
    parameter_group_name = "default.mysql5.6"
    option_group_name = "default:mysql-5-6"
    auto_minor_version_upgrade = false
    db_subnet_group_name = "default"
    vpc_security_group_ids = ["sg-3081fd54", "sg-8b81fdef"]
    tags {
        App = "treeherder"
        Env = "dev"
        Type = "heroku-db"
        workload-type = "production"
    }
}

resource "aws_db_instance" "treeherder-stage-rds" {
    identifier = "treeherder-stage"
    storage_type = "gp2"
    allocated_storage = 500
    engine = "mysql"
    engine_version = "5.6.29"
    instance_class = "db.m4.xlarge"
    username = "th_admin"
    password = "XXXXXXXXXXXXXXXX"
    backup_retention_period = 1
    backup_window = "07:00-07:30"
    maintenance_window = "Sun:08:00-Sun:08:30"
    multi_az = "True"
    port = "3306"
    publicly_accessible = true
    parameter_group_name = "default.mysql5.6"
    auto_minor_version_upgrade = "False"
    db_subnet_group_name = "${aws_db_subnet_group.treeherder-dbgrp.name}"
    vpc_security_group_ids = ["${aws_security_group.treeherder_heroku-sg.id}"]
    monitoring_role_arn = "arn:aws:iam::699292812394:role/rds-monitoring-role"
    monitoring_interval = 60
    tags {
        Name = "treeherder-stage-rds"
        BugID = "1176486"
    }
}

resource "aws_db_instance" "treeherder-prod-rds" {
    identifier = "treeherder-prod"
    storage_type = "gp2"
    allocated_storage = 750
    engine = "mysql"
    engine_version = "5.6.29"
    instance_class = "db.m4.2xlarge"
    username = "th_admin"
    password = "XXXXXXXXXXXXXXXX"
    backup_retention_period = 1
    backup_window = "07:00-07:30"
    maintenance_window = "Sun:08:00-Sun:08:30"
    multi_az = "True"
    port = "3306"
    publicly_accessible = false
    parameter_group_name = "th-replication"
    auto_minor_version_upgrade = "False"
    db_subnet_group_name = "${aws_db_subnet_group.treeherder-dbgrp.name}"
    vpc_security_group_ids = ["${aws_security_group.treeherder_heroku-sg.id}"]
    monitoring_role_arn = "arn:aws:iam::699292812394:role/rds-monitoring-role"
    monitoring_interval = 60
    tags {
        Name = "treeherder-prod-rds"
        BugID = "1276307"
    }
}
