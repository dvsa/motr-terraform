resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "MOTR ${var.environment} OAI"
}

resource "aws_cloudfront_distribution" "MotrWebCFDistro" {
  count       = "${var.with_cloudfront ? 1 : 0}"
  comment     = "CF distro for MOTR ${var.environment} environment"
  enabled     = true
  aliases     = ["${var.alias_record_name}.${var.public_dns_domain}"]
  price_class = "PriceClass_100"
  web_acl_id  = "${var.waf_acl_id}"

  origin {
    domain_name = "${aws_api_gateway_rest_api.MotrWeb.id}.execute-api.${var.aws_region}.amazonaws.com"
    origin_id   = "motr-web-${var.environment}"
    origin_path = "/${var.environment}"

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }

    custom_header {
      name  = "x-api-key"
      value = "${aws_api_gateway_api_key.MotrWebApiKey.value}"
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "POST", "DELETE", "OPTIONS", "PUT", "PATCH"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "motr-web-${var.environment}"
    compress         = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    max_ttl                = 0
    default_ttl            = 0
  }

  origin {
    domain_name = "${var.bucket_prefix}${var.environment}.s3.amazonaws.com"
    origin_id   = "motr-s3-${var.environment}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path}"
    }
  }

  cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "motr-s3-${var.environment}"
    path_pattern     = "/assets/*"
    compress         = false

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    max_ttl                = 31536000
    default_ttl            = 86400
  }

  cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "motr-s3-${var.environment}"
    path_pattern     = "/errorpages/*"
    compress         = false

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    max_ttl                = 31536000
    default_ttl            = 86400
  }

  viewer_certificate {
    acm_certificate_arn      = "${data.aws_acm_certificate.MotrWebCFDistroCert.arn}"
    minimum_protocol_version = "TLSv1"
    ssl_support_method       = "sni-only"
  }

  logging_config {
    include_cookies = false
    bucket          = "${var.logging_bucket == "" ? "${var.bucket_prefix}${var.environment}.s3.amazonaws.com" : var.logging_bucket}"
    prefix          = "${var.logging_bucket == "" ? "logs/cloudfront/" : "${var.environment}/cloudfront"}"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"

      # restriction_type = "whitelist"
      # locations        = ["GB"]
    }
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = "403"
    response_code         = "403"
    response_page_path    = "/errorpages/service-unavailable.html"
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = "500"
    response_code         = "500"
    response_page_path    = "/errorpages/service-unavailable.html"
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = "502"
    response_code         = "502"
    response_page_path    = "/errorpages/service-unavailable.html"
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = "503"
    response_code         = "503"
    response_page_path    = "/errorpages/service-unavailable.html"
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = "504"
    response_code         = "504"
    response_page_path    = "/errorpages/service-unavailable.html"
  }

  tags {
    Name        = "${var.project}-${var.environment}-MotrWebCFDistro"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }

  depends_on = ["aws_cloudfront_origin_access_identity.oai",
    "aws_api_gateway_api_key.MotrWebApiKey",
  ]
}
