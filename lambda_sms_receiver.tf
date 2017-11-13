resource "aws_lambda_function" "MotrSmsReceiver" {
  description   = "MotrSmsReceiver"
  runtime       = "java8"
  s3_bucket     = "${aws_s3_bucket.MOTRS3Bucket.bucket}"
  s3_key        = "lambdas/${var.MotrSmsReceiver_s3_key}"
  function_name = "MotrSmsReceiver-${var.environment}"
  role          = "${aws_iam_role.MotrSmsReceiverLambda.arn}"
  handler       = "uk.gov.dvsa.motr.smsreceiver.handler.EventHandler::handle"
  publish       = "${var.MotrSmsReceiver_publish}"
  memory_size   = "${var.MotrSmsReceiver_mem_size}"
  timeout       = "${var.MotrSmsReceiver_timeout}"
  kms_key_arn   = "${var.kms_key_arn}"

  environment {
    variables = {
      LOG_LEVEL                                   = "${var.sms_receiver_log_level}"
      REGION                                      = "${var.aws_region}"
      DB_TABLE_SUBSCRIPTION                       = "motr-${var.environment}-subscription"
      DB_TABLE_CANCELLED_SUBSCRIPTION             = "motr-${var.environment}-cancelled_subscription"
      NOTIFY_BEARER_TOKEN                         = "${var.sms_receiver_notify_bearer_token}"
      GOV_NOTIFY_API_TOKEN                        = "${var.gov_notify_api_token}"
      SMS_UNSUBSCRIPTION_CONFIRMATION_TEMPLATE_ID = "${var.sms_unsubscription_confirmation_template_id}"
    }
  }
}

resource "aws_lambda_alias" "MotrSmsReceiverAlias" {
  name             = "${var.environment}"
  description      = "Alias for ${aws_lambda_function.MotrSmsReceiver.function_name}"
  function_name    = "${aws_lambda_function.MotrSmsReceiver.arn}"
  function_version = "${var.MotrSmsReceiver_ver}"
}

resource "aws_lambda_permission" "Allow_APIGatewaySmsReceiver" {
  function_name = "${aws_lambda_function.MotrSmsReceiver.function_name}"
  qualifier     = "${aws_lambda_alias.MotrSmsReceiverAlias.name}"
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.MotrSmsReceiver.id}/*/*/*"

  depends_on = ["aws_api_gateway_rest_api.MotrSmsReceiver",
    "aws_api_gateway_integration.LambdaRootSmsReceiverPOST",
  ]
}
