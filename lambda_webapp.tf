resource "aws_lambda_function" "MotrWebHandler" {
  description   = "MotrWebHandler"
  runtime       = "java8"
  s3_bucket     = "${aws_s3_bucket.MOTRS3Bucket.bucket}"
  s3_key        = "lambdas/${var.MotrWebHandler_s3_key}"
  function_name = "MotrWebHandler-${var.environment}"
  role          = "${aws_iam_role.MotrWebAppLambda.arn}"
  handler       = "uk.gov.dvsa.motr.web.handler.MotrWebHandler::handleRequest"
  publish       = "${var.MotrWebHandler_publish}"
  memory_size   = "${var.MotrWebHandler_mem_size}"
  timeout       = "${var.MotrWebHandler_timeout}"
  kms_key_arn   = "${var.kms_key_arn}"

  environment {
    variables = {
      LOG_LEVEL                                            = "${var.webapp_log_level}"
      REGION                                               = "${var.aws_region}"
      STATIC_ASSETS_HASH                                   = "${var.static_assets_hash}"
      STATIC_ASSETS_URL                                    = "${var.with_cloudfront ? "${var.base_url}/assets" : "https://s3-${var.aws_region}.amazonaws.com/${aws_s3_bucket.MOTRS3Bucket.bucket}/assets/"}"
      DB_TABLE_SUBSCRIPTION                                = "motr-${var.environment}-subscription"
      DB_TABLE_PENDING_SUBSCRIPTION                        = "motr-${var.environment}-pending_subscription"
      DB_TABLE_CANCELLED_SUBSCRIPTION                      = "motr-${var.environment}-cancelled_subscription"
      DB_TABLE_SMS_CONFIRMATION                            = "motr-${var.environment}-sms_confirmation"
      MOT_TEST_REMINDER_INFO_API_URI                       = "${var.mot_test_reminder_info_api_uri == "" ? "https://${aws_api_gateway_rest_api.MotrWeb.id}.execute-api.${var.aws_region}.amazonaws.com/${var.environment}/mot-test-reminder-mock/vehicles/{registration}" : var.mot_test_reminder_info_api_uri}"
      GOV_NOTIFY_API_TOKEN                                 = "${var.gov_notify_api_token}"
      CONFIRM_EMAIL_NOTIFICATION_TEMPLATE_ID               = "${var.confirm_email_notification_template_id}"
      CONFIRMATION_TEMPLATE_ID                             = "${var.confirmation_template_id}"
      SMS_CONFIRM_PHONE_TEMPLATE_ID                        = "${var.sms_confirm_phone_template_id}"
      SMS_CONFIRMATION_TEMPLATE_ID                         = "${var.sms_confirmation_template_id}"
      BASE_URL                                             = "${var.base_url == "" ? "https://${aws_api_gateway_rest_api.MotrWeb.id}.execute-api.${var.aws_region}.amazonaws.com/${var.environment}/" : var.base_url}"
      WARM_UP                                              = "${var.webapp_warm_up}"
      MOT_TEST_REMINDER_INFO_API_CLIENT_READ_TIMEOUT       = "${var.mot_test_reminder_info_api_client_read_timeout}"
      MOT_TEST_REMINDER_INFO_API_CLIENT_CONNECTION_TIMEOUT = "${var.mot_test_reminder_info_api_client_connection_timeout}"
      WARM_UP_TIMEOUT_SEC                                  = "${var.webapp_warm_up_timeout_sec}"
      RELEASE_VERSION                                      = "${var.release_version}"
      MOT_TEST_REMINDER_INFO_TOKEN                         = "${var.mot_test_reminder_info_token}"
      FEATURE_TOGGLE_SMS                                   = "${var.feature_toggle_sms}"
    }
  }

  depends_on = ["aws_api_gateway_rest_api.MotrWeb"]
}

resource "aws_lambda_alias" "MotrWebHandlerAlias" {
  name             = "${var.environment}"
  description      = "Alias for ${aws_lambda_function.MotrWebHandler.function_name}"
  function_name    = "${aws_lambda_function.MotrWebHandler.arn}"
  function_version = "${var.MotrWebHandler_ver}"
}

resource "aws_lambda_permission" "Allow_APIGateway" {
  function_name = "${aws_lambda_function.MotrWebHandler.function_name}"
  qualifier     = "${aws_lambda_alias.MotrWebHandlerAlias.name}"
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.MotrWeb.id}/*/*/*"

  depends_on = ["aws_api_gateway_rest_api.MotrWeb",
    "aws_api_gateway_integration.LambdaRootGET",
  ]
}
