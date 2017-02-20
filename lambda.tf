####################################################################################################################################
# WEBAPP

resource "aws_lambda_function" "MotrWebHandler" {
  description       = "MotrWebHandler"
  runtime           = "java8"
  s3_bucket         = "${aws_s3_bucket.MOTRS3Bucket.bucket}"
  s3_key            = "lambdas/${var.MotrWebHandler_s3_key}"
  function_name     = "MotrWebHandler-${var.environment}"
  role              = "${aws_iam_role.MotrWebAppLambda.arn}"
  handler           = "uk.gov.dvsa.motr.web.handler.MotrWebHandler::handleRequest"
  publish           = "${var.MotrWebHandler_publish}"
  memory_size       = "${var.MotrWebHandler_mem_size}"
  timeout           = "${var.MotrWebHandler_timeout}"
  kms_key_arn       = "${aws_kms_key.MOTR_Lambda_Key.arn}"
  environment {
    variables = {
      LOG_LEVEL                      = "${var.webapp_log_level}"
      REGION                         = "${var.aws_region}"
      STATIC_ASSETS_HASH             = "${var.static_assets_hash}"
      STATIC_ASSETS_URL              = "https://s3-${var.aws_region}.amazonaws.com/${aws_s3_bucket.MOTRS3Bucket.bucket}/assets/"
      DB_TABLE_SUBSCRIPTION          = "motr-${var.environment}-subscription"
      DB_TABLE_PENDING_SUBSCRIPTION  = "motr-${var.environment}-pending_subscription"
      MOT_TEST_REMINDER_INFO_API_URI = "${var.mot_test_reminder_info_endpoint == "" ? "https://${aws_api_gateway_rest_api.MotrWeb.id}.execute-api.${var.aws_region}.amazonaws.com/${var.environment}/mock-moth" : var.mot_test_reminder_info_endpoint}"
      GOV_NOTIFY_API_TOKEN           = "${var.gov_notify_api_token}"
      CONFIRMATION_TEMPLATE_ID       = "${var.confirmation_template_id}"
      BASE_URL                       = "${var.base_url == "" ? "https://${aws_api_gateway_rest_api.MotrWeb.id}.execute-api.${var.aws_region}.amazonaws.com/${var.environment}/" : var.base_url}"
      WARM_UP                        = "${var.webapp_warm_up}"
      WARM_UP_TIMEOUT_SEC            = "${var.webapp_warm_up_timeout_sec}"
    }
  }
  depends_on        = ["aws_api_gateway_rest_api.MotrWeb"]
}

resource "aws_lambda_alias" "MotrWebHandlerAlias" {
  name             = "${var.environment}"
  description      = "Alias for ${aws_lambda_function.MotrWebHandler.function_name}"
  function_name    = "${aws_lambda_function.MotrWebHandler.arn}"
  function_version = "${var.MotrWebHandler_ver}"
}

####################################################################################################################################
# SUBSCRIPTION LOADER

resource "aws_lambda_function" "MotrSubscriptionLoader" {
  description   = "MotrSubscriptionLoader"
  runtime       = "java8"
  s3_bucket     = "${aws_s3_bucket.MOTRS3Bucket.bucket}"
  s3_key        = "lambdas/${var.MotrSubscriptionLoader_s3_key}"
  function_name = "MotrSubscriptionLoader-${var.environment}"
  role          = "${aws_iam_role.MotrSubscriptionLoaderLambda.arn}"
  handler       = "uk.gov.dvsa.motr.subscriptionloader.handler.EventHandler::handle"
  publish       = "${var.MotrSubscriptionLoader_publish}"
  memory_size   = "${var.MotrSubscriptionLoader_mem_size}"
  timeout       = "${var.MotrSubscriptionLoader_timeout}"
  kms_key_arn   = "${aws_kms_key.MOTR_Lambda_Key.arn}"
  environment {
    variables = {
      LOG_LEVEL               = "${var.subscr_loader_log_level}"
      REGION                  = "${var.aws_region}"
      DB_TABLE_SUBSCRIPTION   = "motr-${var.environment}-subscription"
      SUBSCRIPTIONS_QUEUE_URL = "${aws_sqs_queue.MotrSubscriptionsQueue.id}"
    }
  }
}

resource "aws_lambda_alias" "MotrSubscriptionLoader" {
  name             = "${var.environment}"
  description      = "Alias for ${aws_lambda_function.MotrSubscriptionLoader.function_name}"
  function_name    = "${aws_lambda_function.MotrSubscriptionLoader.arn}"
  function_version = "${var.MotrSubscriptionLoader_ver}"
}

####################################################################################################################################
# NOTIFIER

resource "aws_lambda_function" "MotrNotifier" {
  description   = "MotrNotifier"
  runtime       = "java8"
  s3_bucket     = "${aws_s3_bucket.MOTRS3Bucket.bucket}"
  s3_key        = "lambdas/${var.MotrNotifier_s3_key}"
  function_name = "MotrNotifier-${var.environment}"
  role          = "${aws_iam_role.MotrNotifierLambda.arn}"
  handler       = "uk.gov.dvsa.motr.notifier.handler.EventHandler::handle"
  publish       = "${var.MotrNotifier_publish}"
  memory_size   = "${var.MotrNotifier_mem_size}"
  timeout       = "${var.MotrNotifier_timeout}"
  kms_key_arn   = "${aws_kms_key.MOTR_Lambda_Key.arn}"
  environment {
    variables = {
      LOG_LEVEL               = "${var.notifier_log_level}"
      REGION                  = "${var.aws_region}"
      DB_TABLE_SUBSCRIPTION   = "motr-${var.environment}-subscription"
      SUBSCRIPTIONS_QUEUE_URL = "${aws_sqs_queue.MotrSubscriptionsQueue.id}"
    }
  }
}

resource "aws_lambda_alias" "MotrNotifier" {
  name             = "${var.environment}"
  description      = "Alias for ${aws_lambda_function.MotrNotifier.function_name}"
  function_name    = "${aws_lambda_function.MotrNotifier.arn}"
  function_version = "${var.MotrNotifier_ver}"
}

####################################################################################################################################
# PERMISSIONS

resource "aws_lambda_permission" "Allow_APIGateway" {
  function_name = "${aws_lambda_function.MotrWebHandler.function_name}"
  qualifier     = "${aws_lambda_alias.MotrWebHandlerAlias.name}"
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.MotrWeb.id}/*/*/*"
  depends_on    = [ "aws_api_gateway_rest_api.MotrWeb"
                  , "aws_api_gateway_integration.LambdaRootGET"
  ]
}
