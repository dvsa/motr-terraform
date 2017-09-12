resource "aws_lambda_function" "MotrBouncingEmailCleaner" {
  description   = "MotrBouncingEmailCleaner"
  runtime       = "java8"
  s3_bucket     = "${aws_s3_bucket.MOTRS3Bucket.bucket}"
  s3_key        = "lambdas/${var.MotrBouncingEmailCleaner_s3_key}"
  function_name = "MotrBouncingEmailCleaner-${var.environment}"
  role          = "${aws_iam_role.MotrBouncingEmailCleanerLambda.arn}"
  handler       = "uk.gov.dvsa.motr.handler.MotrBouncingEmailCleanerHandler::handleRequest"
  publish       = "${var.MotrBouncingEmailCleaner_publish}"
  memory_size   = "${var.MotrBouncingEmailCleaner_mem_size}"
  timeout       = "${var.MotrBouncingEmailCleaner_timeout}"
  kms_key_arn   = "${var.kms_key_arn}"

  environment {
    variables = {
      LOG_LEVEL                               = "${var.bouncing_email_cleaner_log_level}"
      REGION                                  = "${var.aws_region}"
      DB_TABLE_SUBSCRIPTION                   = "motr-${var.environment}-subscription"
      DB_TABLE_CANCELLED_SUBSCRIPTION         = "motr-${var.environment}-cancelled_subscription"
      GOV_NOTIFY_API_TOKEN                    = "${var.gov_notify_api_token}"
      GOV_NOTIFY_STATUS_REPORT_EMAIL_TEMPLATE = "${var.gov_notify_status_email_template}"
      STATUS_EMAIL_RECIPIENTS                 = "${var.status_email_recipients}"
    }
  }
}

resource "aws_lambda_alias" "MotrBouncingEmailCleaner" {
  name             = "${var.environment}"
  description      = "Alias for ${aws_lambda_function.MotrBouncingEmailCleaner.function_name}"
  function_name    = "${aws_lambda_function.MotrBouncingEmailCleaner.arn}"
  function_version = "${var.MotrBouncingEmailCleaner_ver}"
}

resource "aws_lambda_permission" "Cleaner_Allow_CloudWatchEvent" {
  function_name = "${aws_lambda_function.MotrBouncingEmailCleaner.function_name}"
  qualifier     = "${aws_lambda_alias.MotrBouncingEmailCleaner.name}"
  statement_id  = "AllowExecutionFromCloudWatchEvent"
  action        = "lambda:InvokeFunction"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.MotrBouncingEmailCleanerStart.arn}"
}
