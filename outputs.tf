output "api_gateway_url" {
  value = "https://${aws_api_gateway_rest_api.MotrWeb.id}.execute-api.${var.aws_region}.amazonaws.com/${var.environment}/"
}

output "cloudfront_url" {
  value = "${var.with_cloudfront ? "https://${aws_cloudfront_distribution.MotrWebCFDistro.domain_name}" : "N/A"}"
}

output "website_url" {
  value = "${var.with_cloudfront ? "https://${aws_route53_record.MotrWeb.fqdn}" : "N/A"}"
}
