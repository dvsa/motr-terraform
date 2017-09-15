data "aws_acm_certificate" "MotrWebCFDistroCert" {
  count    = "${var.with_cloudfront ? 1 : 0}"
  provider = "aws.cfdistro_cert"
  domain   = "${var.alias_record_name}.${var.public_dns_domain}"
  statuses = ["ISSUED"]
}

data "aws_acm_certificate" "SMSReceiver" {
  count    = "${var.with_cloudfront ? 1 : 0}"
  provider = "aws.cfdistro_cert"
  domain   = "${var.sms_receiver_alias_record}.${var.public_dns_domain}"
  statuses = ["ISSUED"]
}
