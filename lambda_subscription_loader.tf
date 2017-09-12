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
