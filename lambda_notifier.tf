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
      LOG_LEVEL                                  = "${var.notifier_log_level}"
      REGION                                     = "${var.aws_region}"
      DB_TABLE_SUBSCRIPTION                      = "motr-${var.environment}-subscription"
      SUBSCRIPTIONS_QUEUE_URL                    = "${aws_sqs_queue.MotrSubscriptionsQueue.id}"
      ONE_MONTH_NOTIFICATION_TEMPLATE_ID         = "${var.one_month_notification_template_id}"
      TWO_WEEK_NOTIFICATION_TEMPLATE_ID          = "${var.two_week_notification_template_id}"
      ONE_DAY_AFTER_NOTIFICATION_TEMPLATE_ID     = "${var.one_day_after_notification_template_id}"
      SMS_ONE_MONTH_NOTIFICATION_TEMPLATE_ID     = "${var.sms_one_month_notification_template_id}"
      SMS_TWO_WEEK_NOTIFICATION_TEMPLATE_ID      = "${var.sms_two_week_notification_template_id}"
      SMS_ONE_DAY_AFTER_NOTIFICATION_TEMPLATE_ID = "${var.sms_one_day_after_notification_template_id}"
      MOT_API_MOT_TEST_NUMBER_URI                = "${var.mot_api_mot_test_number_uri == "" ? "https://${aws_api_gateway_rest_api.MotrWeb.id}.execute-api.${var.aws_region}.amazonaws.com/${var.environment}/mot-test-reminder-mock/mot-tests/{number}" : var.mot_api_mot_test_number_uri}"
      MOT_API_DVLA_ID_URI                        = "${var.mot_api_dvla_id_uri == "" ? "https://${aws_api_gateway_rest_api.MotrWeb.id}.execute-api.${var.aws_region}.amazonaws.com/${var.environment}/mot-test-reminder-mock/mot-tests-by-dvla-id/{dvlaId}" : var.mot_api_dvla_id_uri}"
      GOV_NOTIFY_API_TOKEN                       = "${var.gov_notify_api_token}"
      MOT_TEST_REMINDER_INFO_TOKEN               = "${var.mot_test_reminder_info_token}"
      WORKER_COUNT                               = "${var.worker_count_notifier}"
      MESSAGE_VISIBILITY_TIMEOUT                 = "${var.message_visibility_timeout_notifier}"
      VEHICLE_API_CLIENT_TIMEOUT                 = "${var.vehicle_api_client_timeout_notifier}"
      MESSAGE_RECEIVE_TIMEOUT                    = "${var.message_receive_timeout_notifier}"
      REMAINING_TIME_THRESHOLD                   = "${var.remaining_time_threshold_notifier}"
      WEB_BASE_URL                               = "${var.base_url == "" ? "https://${aws_api_gateway_rest_api.MotrWeb.id}.execute-api.${var.aws_region}.amazonaws.com/${var.environment}/" : var.base_url}"
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
