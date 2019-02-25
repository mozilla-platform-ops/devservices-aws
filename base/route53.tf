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

# Create subdomain for 'devservices.mozops.net'
resource "aws_route53_zone" "devservices" {
    name = "devservices.mozops.net"
}
resource "aws_route53_record" "devservices_mozops" {
    zone_id = "${aws_route53_zone.mozops.zone_id}"
    name = "devservices.mozops.net"
    type = "NS"
    ttl = "30"
    records = ["${aws_route53_zone.devservices.name_servers.0}",
               "${aws_route53_zone.devservices.name_servers.1}",
               "${aws_route53_zone.devservices.name_servers.2}",
               "${aws_route53_zone.devservices.name_servers.3}"]
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

# This NS record delegates the subdomain 'relops.mozops.net' to
# the relops aws account.  The authoritative name servers can be
# queried with the aws cli tools.
# eg. aws route53 get-hosted-zone --id Z2GVPYEJ4ZO8P1
resource "aws_route53_record" "relops_mozops" {
    zone_id = "${aws_route53_zone.mozops.zone_id}"
    name = "relops.mozops.net"
    type = "NS"
    ttl = "300"
    records = ["ns-1426.awsdns-50.org",
               "ns-545.awsdns-04.net",
               "ns-1575.awsdns-04.co.uk",
               "ns-159.awsdns-19.com"]
}

# This record is used by a server that receives Firefox build
# system metrics. The record should be temporary until more permanent
# ingestion is stood up. Tracked in bug 1242017.
resource "aws_route53_record" "build_metrics_ingest" {
    zone_id = "${aws_route53_zone.mozops.zone_id}"
    name = "build-metrics-ingest.mozops.net"
    type = "A"
    ttl = "60"
    # This is an AWS instance maintained by ekyle in a separate
    # AWS account.
    records = ["54.149.253.188"]
}

resource "aws_route53_record" "jumphost_use1_devservices_mozops_net" {
    zone_id = "${aws_route53_zone.devservices.zone_id}"
    name = "jumphost.use1.devservices.mozops.net"
    type = "A"
    ttl = "60"
    records = ["${aws_eip.jumphost_use1_eip.public_ip}"]
}
resource "aws_route53_record" "jumphost_usw2_devservices_mozops_net" {
    zone_id = "${aws_route53_zone.devservices.zone_id}"
    name = "jumphost.usw2.devservices.mozops.net"
    type = "A"
    ttl = "60"
    records = ["${aws_eip.jumphost_usw2_eip.public_ip}"]
}
