resource "aws_api_gateway_rest_api" "MotrSmsReceiver" {
  name        = "motr-sms-receiver-${var.environment}"
  description = "MOTR SMS Receiver ${var.environment}"
}

####################################################################################################################################
# API GATEWAY RESOURCE FOR SMS RECEIVER

resource "aws_api_gateway_method" "LambdaRootSmsReceiverPOST" {
  rest_api_id      = "${aws_api_gateway_rest_api.MotrSmsReceiver.id}"
  resource_id      = "${aws_api_gateway_rest_api.MotrSmsReceiver.root_resource_id}"
  http_method      = "POST"
  authorization    = "NONE"
  api_key_required = "false"
}

# integration between POST method to Lambda
resource "aws_api_gateway_integration" "LambdaRootSmsReceiverPOST" {
  rest_api_id             = "${aws_api_gateway_rest_api.MotrSmsReceiver.id}"
  resource_id             = "${aws_api_gateway_rest_api.MotrSmsReceiver.root_resource_id}"
  http_method             = "${aws_api_gateway_method.LambdaRootSmsReceiverPOST.http_method}"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.MotrSmsReceiver.arn}:${aws_lambda_alias.MotrSmsReceiverAlias.name}/invocations"
  integration_http_method = "POST"
}

resource "aws_api_gateway_method_response" "LambdaRootSmsReceiverPOST_200" {
  rest_api_id = "${aws_api_gateway_rest_api.MotrSmsReceiver.id}"
  resource_id = "${aws_api_gateway_rest_api.MotrSmsReceiver.root_resource_id}"
  http_method = "${aws_api_gateway_method.LambdaRootSmsReceiverPOST.http_method}"
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Date"           = true
    "method.response.header.ETag"           = true
    "method.response.header.Content-Length" = true
    "method.response.header.Content-Type"   = true
    "method.response.header.Last-Modified"  = true
  }
}

####################################################################################################################################
# API GATEWAY DEPLOYMENT

resource "aws_api_gateway_deployment" "DeploymentSMSReceiver" {
  rest_api_id = "${aws_api_gateway_rest_api.MotrSmsReceiver.id}"
  stage_name  = "${var.environment}"

  depends_on = [
    "aws_api_gateway_method.LambdaRootSmsReceiverPOST",
    "aws_api_gateway_integration.LambdaRootSmsReceiverPOST",
  ]
}

####################################################################################################################################
# API GATEWAY CUSTOM DOMAIN NAME AND PATH MAPPING

resource "aws_api_gateway_domain_name" "SMSReceiver" {
  count           = "${var.with_cloudfront ? 1 : 0}"
  domain_name     = "${var.sms_receiver_alias_record}.${var.public_dns_domain}"
  certificate_arn = "${data.aws_acm_certificate.SMSReceiver.arn}"
}

resource "aws_api_gateway_base_path_mapping" "LambdaRootSmsReceiverBasePathMapping" {
  count       = "${var.with_cloudfront ? 1 : 0}"
  api_id      = "${aws_api_gateway_rest_api.MotrSmsReceiver.id}"
  stage_name  = "${aws_api_gateway_deployment.DeploymentSMSReceiver.stage_name}"
  domain_name = "${aws_api_gateway_domain_name.SMSReceiver.domain_name}"
}

####################################################################################################################################
# USAGE PLAN

resource "aws_api_gateway_usage_plan" "MotrSmsReceiverApiUsagePlan" {
  count       = "${var.with_cloudfront ? 1 : 0}"
  name        = "motr-sms-receiver-${var.environment}-up"
  description = "Usage Plan for MOTR ${var.environment} SMS Receiver"

  api_stages {
    api_id = "${aws_api_gateway_rest_api.MotrSmsReceiver.id}"
    stage  = "${aws_api_gateway_deployment.DeploymentSMSReceiver.stage_name}"
  }

  throttle_settings {
    burst_limit = 979
    rate_limit  = 1000
  }
}
