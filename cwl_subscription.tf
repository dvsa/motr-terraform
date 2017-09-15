resource "aws_cloudwatch_log_group" "MotrSubscriptionLoader" {
  count             = "${var.manage_cw_lg_subscr_lambda ? 1 : 0}"
  name              = "/aws/lambda/${aws_lambda_function.MotrSubscriptionLoader.function_name}"
  retention_in_days = "${var.cw_lg_subscr_lambda_retention}"

  tags {
    Name        = "${var.project}-${var.environment}-MotrSubscriptionLoader"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}

resource "aws_cloudwatch_event_rule" "MotrLoaderStart" {
  name                = "motr-loader-start-${var.environment}"
  description         = "MOTR Loader Start (${var.environment}) event rule | Schedule: ${var.motr_loader_schedule}"
  is_enabled          = "${var.motr_loader_enabled}"
  schedule_expression = "${var.motr_loader_schedule}"
}

resource "aws_cloudwatch_event_target" "MotrLoaderStart" {
  rule      = "${aws_cloudwatch_event_rule.MotrLoaderStart.name}"
  target_id = "${aws_cloudwatch_event_rule.MotrLoaderStart.name}-target"
  arn       = "${aws_lambda_alias.MotrSubscriptionLoader.arn}"
}

resource "aws_cloudwatch_log_metric_filter" "MotrSubscriptionLoaderLoadingError_log_metric_filter" {
  name           = "MotrSubscriptionLoaderLoadingError_log_metric_filter"
  pattern        = "{ $.message = LOADING-ERROR }"
  log_group_name = "/aws/lambda/${aws_lambda_function.MotrSubscriptionLoader.function_name}"

  metric_transformation {
    name      = "${var.project}-${var.environment}-MotrSubscriptionLoader-LoadingError"
    namespace = "${var.project}-${var.environment}-MotrSubscriptionLoader-LoadingError"
    value     = "1"
  }

  depends_on = ["aws_cloudwatch_log_group.MotrSubscriptionLoader"]
}

resource "aws_cloudwatch_log_metric_filter" "MotrSubscriptionLoaderLoadingSuccess_log_metric_filter" {
  name           = "MotrSubscriptionLoaderLoadingSuccess_log_metric_filter"
  pattern        = "{ $.message = LOADING-SUCCESS }"
  log_group_name = "/aws/lambda/${aws_lambda_function.MotrSubscriptionLoader.function_name}"

  metric_transformation {
    name      = "${var.project}-${var.environment}-MotrSubscriptionLoader-LoadingSuccess"
    namespace = "${var.project}-${var.environment}-MotrSubscriptionLoader-LoadingSuccess"
    value     = "1"
  }

  depends_on = ["aws_cloudwatch_log_group.MotrSubscriptionLoader"]
}

resource "aws_cloudwatch_log_metric_filter" "MotrSubscriptionLoader_MiscError_log_metric_filter" {
  name           = "MotrSubscriptionLoader_MiscError_log_metric_filter"
  pattern        = "{ $.level = ERROR }"
  log_group_name = "/aws/lambda/${aws_lambda_function.MotrSubscriptionLoader.function_name}"

  metric_transformation {
    name      = "${var.project}-${var.environment}-MotrSubscriptionLoader-MiscError"
    namespace = "${var.project}-${var.environment}-MotrSubscriptionLoader-MiscError"
    value     = "1"
  }

  depends_on = ["aws_cloudwatch_log_group.MotrSubscriptionLoader"]
}
