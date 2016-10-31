# Route53 hosted zone for mozops.net
resource "aws_route53_zone" "mozops" {
   name = "mozops.net"
}
