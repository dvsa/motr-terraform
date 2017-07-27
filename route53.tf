data "aws_route53_zone" "Route53Zone" {
  count        = "${var.with_cloudfront ? 1 : 0}"
  name         = "${var.public_dns_domain}."
  private_zone = false
}

resource "aws_route53_record" "MotrWeb" {
  count   = "${var.with_cloudfront ? 1 : 0}"
  name    = "${var.alias_record_name}"
  zone_id = "${data.aws_route53_zone.Route53Zone.zone_id}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.MotrWebCFDistro.domain_name}"
    zone_id                = "Z2FDTNDATAQYW2"                                             # official cloudfront.net zone_id
    evaluate_target_health = false                                                        # has to be false for CF
  }

  depends_on = ["data.aws_route53_zone.Route53Zone",
    "aws_cloudfront_distribution.MotrWebCFDistro",
  ]
}
