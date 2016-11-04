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

# This NS record delegates the subdomain 'mozreview.mozops.net' to
# the mozreview aws account.  The authoritative name servers can be
# queried with the aws cli tools.
# eg. aws route53 get-hosted-zone --id ZOJF0BEJC8OX3
resource "aws_route53_record" "mozreview_mozops" {
    zone_id = "${aws_route53_zone.mozops.zone_id}"
    name = "mozreview.mozops.net"
    type = "NS"
    ttl = "300"
    records = ["ns-880.awsdns-46.net",
               "ns-2.awsdns-00.com",
               "ns-1819.awsdns-35.co.uk",
               "ns-1522.awsdns-62.org"]
}
