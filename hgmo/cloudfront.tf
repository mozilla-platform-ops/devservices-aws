# Set up a CDN to serve data from S3.
resource "aws_cloudfront_distribution" "bundles" {
    aliases = ["hg.cdn.mozilla.net"]

    origin {
        domain_name = "moz-hg-bundles-us-west-2.s3.amazonaws.com"
        origin_id = "S3-moz-hg-bundles-us-west-2"
    }

    enabled = true
    default_root_object = "index.html"
    http_version = "http1.1"

    logging_config {
        bucket = "moz-devservices-logging.s3.amazonaws.com"
        prefix = "cloudfront/hg-bundles"
    }

    default_cache_behavior {
        allowed_methods = ["HEAD", "GET"]
        cached_methods = ["HEAD", "GET"]
        min_ttl = 0
        max_ttl = 31536000
        default_ttl = 86400
        target_origin_id = "S3-moz-hg-bundles-us-west-2"
        viewer_protocol_policy = "https-only"

        forwarded_values {
            query_string = false
            cookies {
                forward = "none"
            }
        }
    }

    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }

    viewer_certificate {
        acm_certificate_arn = "arn:aws:acm:us-east-1:${data.aws_caller_identity.current.account_id}:certificate/2d14b270-e4ec-4a12-8269-161b65ad5ccf"
        ssl_support_method = "sni-only"
        minimum_protocol_version = "TLSv1"
    }

    tags {
        App = "hgmo"
        Env = "prod"
        Owner = "gps@mozilla.com"
        Bugid = "1185261"
    }
}
