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
  kms_key_arn       = "${var.kms_key_arn}"
  environment {
    variables = {
      LOG_LEVEL                                            = "${var.webapp_log_level}"
      REGION                                               = "${var.aws_region}"
      STATIC_ASSETS_HASH                                   = "${var.static_assets_hash}"
      STATIC_ASSETS_URL                                    = "${var.with_cloudfront ? "${var.base_url}/assets" : "https://s3-${var.aws_region}.amazonaws.com/${aws_s3_bucket.MOTRS3Bucket.bucket}/assets/"}"
      DB_TABLE_SUBSCRIPTION                                = "motr-${var.environment}-subscription"
      DB_TABLE_PENDING_SUBSCRIPTION                        = "motr-${var.environment}-pending_subscription"
      DB_TABLE_CANCELLED_SUBSCRIPTION                      = "motr-${var.environment}-cancelled_subscription"
      MOT_TEST_REMINDER_INFO_API_URI                       = "${var.mot_test_reminder_info_api_uri == "" ? "https://${aws_api_gateway_rest_api.MotrWeb.id}.execute-api.${var.aws_region}.amazonaws.com/${var.environment}/mot-test-reminder-mock/{registration}" : var.mot_test_reminder_info_api_uri}"
      GOV_NOTIFY_API_TOKEN                                 = "${var.gov_notify_api_token}"
      CONFIRM_EMAIL_NOTIFICATION_TEMPLATE_ID               = "${var.confirm_email_notification_template_id}"
      CONFIRMATION_TEMPLATE_ID                             = "${var.confirmation_template_id}"
      BASE_URL                                             = "${var.base_url == "" ? "https://${aws_api_gateway_rest_api.MotrWeb.id}.execute-api.${var.aws_region}.amazonaws.com/${var.environment}/" : var.base_url}"
      WARM_UP                                              = "${var.webapp_warm_up}"
      MOT_TEST_REMINDER_INFO_API_CLIENT_READ_TIMEOUT       = "${var.mot_test_reminder_info_api_client_read_timeout}"
      MOT_TEST_REMINDER_INFO_API_CLIENT_CONNECTION_TIMEOUT = "${var.mot_test_reminder_info_api_client_connection_timeout}"
      WARM_UP_TIMEOUT_SEC                                  = "${var.webapp_warm_up_timeout_sec}"
      MOT_TEST_REMINDER_INFO_TOKEN                         = "${var.mot_test_reminder_info_token}"
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
  kms_key_arn   = "${var.kms_key_arn}"
  environment {
    variables = {
      LOG_LEVEL               = "${var.subscr_loader_log_level}"
      REGION                  = "${var.aws_region}"
      DB_TABLE_SUBSCRIPTION   = "motr-${var.environment}-subscription"
      SUBSCRIPTIONS_QUEUE_URL = "${aws_sqs_queue.MotrSubscriptionsQueue.id}"
      INFLIGHT_BATCHES        = "${var.inflight_batches_loader}"
      POST_PURGE_DELAY        = "${var.post_purge_delay_loader}"
    }
  }
}

resource "aws_lambda_alias" "MotrSubscriptionLoader" {
  name             = "${var.environment}"
  description      = "Alias for ${aws_lambda_function.MotrSubscriptionLoader.function_name}"
  function_name    = "${aws_lambda_function.MotrSubscriptionLoader.arn}"
  function_version = "${var.MotrSubscriptionLoader_ver}"
}

resource "aws_lambda_permission" "Loader_Allow_CloudWatchEvent" {
  function_name = "${aws_lambda_function.MotrSubscriptionLoader.function_name}"
  qualifier     = "${aws_lambda_alias.MotrSubscriptionLoader.name}"
  statement_id  = "AllowExecutionFromCloudWatchEvent"
  action        = "lambda:InvokeFunction"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.MotrLoaderStart.arn}"
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
  kms_key_arn   = "${var.kms_key_arn}"
  environment {
    variables = {
      LOG_LEVEL                          = "${var.notifier_log_level}"
      REGION                             = "${var.aws_region}"
      DB_TABLE_SUBSCRIPTION              = "motr-${var.environment}-subscription"
      SUBSCRIPTIONS_QUEUE_URL            = "${aws_sqs_queue.MotrSubscriptionsQueue.id}"
      ONE_MONTH_NOTIFICATION_TEMPLATE_ID = "${var.one_month_notification_template_id}"
      TWO_WEEK_NOTIFICATION_TEMPLATE_ID  = "${var.two_week_notification_template_id}"
      MOT_TEST_REMINDER_INFO_API_URI     = "${var.mot_test_reminder_info_api_uri == "" ? "https://${aws_api_gateway_rest_api.MotrWeb.id}.execute-api.${var.aws_region}.amazonaws.com/${var.environment}/mot-test-reminder-mock/{registration}" : var.mot_test_reminder_info_api_uri}"
      GOV_NOTIFY_API_TOKEN               = "${var.gov_notify_api_token}"
      MOT_TEST_REMINDER_INFO_TOKEN       = "${var.mot_test_reminder_info_token}"
      WORKER_COUNT                       = "${var.worker_count_notifier}"
      MESSAGE_VISIBILITY_TIMEOUT         = "${var.message_visibility_timeout_notifier}"
      VEHICLE_API_CLIENT_TIMEOUT         = "${var.vehicle_api_client_timeout_notifier}"
      MESSAGE_RECEIVE_TIMEOUT            = "${var.message_receive_timeout_notifier}"
      REMAINING_TIME_THRESHOLD           = "${var.remaining_time_threshold_notifier}"
      WEB_BASE_URL                       = "${var.base_url == "" ? "https://${aws_api_gateway_rest_api.MotrWeb.id}.execute-api.${var.aws_region}.amazonaws.com/${var.environment}/" : var.base_url}"
    }
  }
}

resource "aws_lambda_alias" "MotrNotifier" {
  name             = "${var.environment}"
  description      = "Alias for ${aws_lambda_function.MotrNotifier.function_name}"
  function_name    = "${aws_lambda_function.MotrNotifier.arn}"
  function_version = "${var.MotrNotifier_ver}"
}

resource "aws_lambda_permission" "Notifier_Allow_CloudWatchEvent" {
  function_name = "${aws_lambda_function.MotrNotifier.function_name}"
  qualifier     = "${aws_lambda_alias.MotrNotifier.name}"
  statement_id  = "AllowExecutionFromCloudWatchEvent"
  action        = "lambda:InvokeFunction"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.MotrNotifierStart.arn}"
}

####################################################################################################################################
# NPINGER

resource "aws_lambda_function" "NPinger" {
  description       = "MotrNPinger"
  runtime           = "nodejs4.3"
  filename          = "lambda_warmer/${var.NPinger_lambda_filename}"
  function_name     = "MotrNPinger-${var.environment}"
  role              = "${aws_iam_role.NPingerRole.arn}"
  handler           = "npinger.warmup"
  publish           = "${var.NPinger_publish}"
  memory_size       = "${var.NPinger_mem_size}"
  timeout           = "${var.NPinger_timeout}"
  environment {
    variables = {
      REGION                  = "${var.aws_region}"
      FUNCTION_NAME           = "${aws_lambda_function.MotrWebHandler.function_name}"
      CONCURRENT_TARGET_COUNT = "${var.NPinger_concurrent_target_count}"
      PAYLOAD                 = "${var.NPinger_payload}"
    }
  }
}

resource "aws_lambda_alias" "NPingerAlias" {
  name             = "${var.environment}"
  description      = "Alias for ${aws_lambda_function.NPinger.function_name}"
  function_name    = "${aws_lambda_function.NPinger.arn}"
  function_version = "${var.NPinger_ver}"
}

resource "aws_lambda_permission" "Allow_CloudWatchEvent" {
  function_name = "${aws_lambda_function.NPinger.function_name}"
  qualifier     = "${aws_lambda_alias.NPingerAlias.name}"
  statement_id  = "AllowExecutionFromCloudWatchEvent"
  action        = "lambda:InvokeFunction"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.MOTR-WarmUpEventRule.arn}"
}
