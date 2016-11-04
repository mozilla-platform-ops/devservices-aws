# Route53 hosted zone for mozops.net
resource "aws_route53_zone" "mozops" {
    name = "mozops.net"
    tags {
        Name = "base-ops-r53zone"
        App = "base"
        Env = "ops"
        Type = "r53zone"
        Owner = "relops"
    }
}
