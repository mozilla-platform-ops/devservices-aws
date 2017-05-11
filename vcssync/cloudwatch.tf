resource "aws_cloudwatch_log_group" "vcssync" {
    name = "/vcssync"
    retention_in_days = 30
    tags = {
        App = "VCS Sync"
        Env = "prod"
        Owner = "gps@mozilla.com"
        Bugid = "1364231"
    }
}
