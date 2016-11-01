resource "aws_s3_bucket" "webhooks_bucket" {
    bucket = "moz-github-webhooks"
    acl = "private"
    tags {
        App = "GitHub WebHooks"
        Env = "prod"
        Owner = "gps@mozilla.com"
        Bugid = "1170600"
    }
}
