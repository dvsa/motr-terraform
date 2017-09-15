resource "aws_cloudwatch_log_group" "MotrNotifier" {
  count             = "${var.manage_cw_lg_notifier_lambda ? 1 : 0}"
  name              = "/aws/lambda/${aws_lambda_function.MotrNotifier.function_name}"
  retention_in_days = "${var.cw_lg_notifier_lambda_retention}"

  tags {
    Name        = "${var.project}-${var.environment}-MotrNotifier"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}

resource "aws_cloudwatch_event_rule" "MotrNotifierStart" {
  name                = "motr-notifier-start-${var.environment}"
  description         = "MOTR MotrNotifierStart Start (${var.environment}) event rule | Schedule: ${var.motr_notifier_schedule}"
  is_enabled          = "${var.motr_notifier_enabled}"
  schedule_expression = "${var.motr_notifier_schedule}"
}

resource "aws_cloudwatch_event_target" "MotrNotifierStart" {
  rule      = "${aws_cloudwatch_event_rule.MotrNotifierStart.name}"
  target_id = "${aws_cloudwatch_event_rule.MotrNotifierStart.name}-target"
  arn       = "${aws_lambda_alias.MotrNotifier.arn}"
}

resource "aws_cloudwatch_log_metric_filter" "MotrNotifierSubscriptionProcessingFailed_log_metric_filter" {
  name           = "MotrNotifierSubscriptionProcessingFailed_log_metric_filter"
  pattern        = "{ $.message = SUBSCRIPTION-PROCESSING-FAILED }"
  log_group_name = "/aws/lambda/${aws_lambda_function.MotrNotifier.function_name}"

  metric_transformation {
    name      = "${var.project}-${var.environment}-MotrNotifier-SubscriptionProcessingFailed"
    namespace = "${var.project}-${var.environment}-MotrNotifier-SubscriptionProcessingFailed"
    value     = "1"
  }

  depends_on = ["aws_cloudwatch_log_group.MotrNotifier"]
}

resource "aws_cloudwatch_log_metric_filter" "MotrNotifierDvlaIdUpdatedToMotTestNumber_log_metric_filter" {
  name           = "MotrNotifierDvlaIdUpdatedToMotTestNumber_log_metric_filter"
  pattern        = "{ $.message = DVLA-ID-UPDATED-TO-MOT-TEST-NUMBER }"
  log_group_name = "/aws/lambda/${aws_lambda_function.MotrNotifier.function_name}"

  metric_transformation {
    name      = "${var.project}-${var.environment}-MotrNotifier-DvlaIdUpdatedToMotTestNumber"
    namespace = "${var.project}-${var.environment}-MotrNotifier-DvlaIdUpdatedToMotTestNumber"
    value     = "1"
  }

  depends_on = ["aws_cloudwatch_log_group.MotrNotifier"]
}

resource "aws_cloudwatch_log_metric_filter" "MotrNotifierSubscriptionQueueItemRemovalFailed_log_metric_filter" {
  name           = "MotrNotifierSubscriptionQueueItemRemovalFailed_log_metric_filter"
  pattern        = "{ $.message = SUBSCRIPTION-QUEUE-ITEM-REMOVAL-FAILED }"
  log_group_name = "/aws/lambda/${aws_lambda_function.MotrNotifier.function_name}"

  metric_transformation {
    name      = "${var.project}-${var.environment}-MotrNotifier-SubscriptionQueueItemRemovalFailed"
    namespace = "${var.project}-${var.environment}-MotrNotifier-SubscriptionQueueItemRemovalFailed"
    value     = "1"
  }

  depends_on = ["aws_cloudwatch_log_group.MotrNotifier"]
}

resource "aws_cloudwatch_log_metric_filter" "MotrNotifierVehicleDetailsRetrievalFailed_log_metric_filter" {
  name           = "MOTRNotifierVehicleDetailsRetrievalFailed_log_metric_filter"
  pattern        = "{ $.message = VEHICLE-DETAILS-RETRIEVAL-FAILED }"
  log_group_name = "/aws/lambda/${aws_lambda_function.MotrNotifier.function_name}"

  metric_transformation {
    name      = "${var.project}-${var.environment}-MotrNotifier-VehicleDetailsRetrievalFailed"
    namespace = "${var.project}-${var.environment}-MotrNotifier-VehicleDetailsRetrievalFailed"
    value     = "1"
  }

  depends_on = ["aws_cloudwatch_log_group.MotrNotifier"]
}

resource "aws_cloudwatch_log_metric_filter" "MotrNotifierUnloadingTimedOut_log_metric_filter" {
  name           = "MotrNotifierUnloadingTimedOut_log_metric_filter"
  pattern        = "{ $.message = UNLOADING-TIMEDOUT }"
  log_group_name = "/aws/lambda/${aws_lambda_function.MotrNotifier.function_name}"

  metric_transformation {
    name      = "${var.project}-${var.environment}-MotrNotifier-UnloadingTimedOut"
    namespace = "${var.project}-${var.environment}-MotrNotifier-UnloadingTimedOut"
    value     = "1"
  }

  depends_on = ["aws_cloudwatch_log_group.MotrNotifier"]
}

resource "aws_cloudwatch_log_metric_filter" "MotrNotifierOneMonthReminderSuccess_log_metric_filter" {
  name           = "MotrNotifierOneMonthReminderSuccess_log_metric_filter"
  pattern        = "{ $.message = ONE-MONTH-EMAIL-SUCCESS }"
  log_group_name = "/aws/lambda/${aws_lambda_function.MotrNotifier.function_name}"

  metric_transformation {
    name      = "${var.project}-${var.environment}-MotrNotifier-OneMonthReminderSuccess"
    namespace = "${var.project}-${var.environment}-MotrNotifier-OneMonthReminderSuccess"
    value     = "1"
  }

  depends_on = ["aws_cloudwatch_log_group.MotrNotifier"]
}

resource "aws_cloudwatch_log_metric_filter" "MotrNotifierTwoWeekReminderSuccess_log_metric_filter" {
  name           = "MotrNotifierTwoWeekReminderSuccess_log_metric_filter"
  pattern        = "{ $.message = TWO-WEEK-EMAIL-SUCCESS }"
  log_group_name = "/aws/lambda/${aws_lambda_function.MotrNotifier.function_name}"

  metric_transformation {
    name      = "${var.project}-${var.environment}-MotrNotifier-TwoWeekReminderSuccess"
    namespace = "${var.project}-${var.environment}-MotrNotifier-TwoWeekReminderSuccess"
    value     = "1"
  }

  depends_on = ["aws_cloudwatch_log_group.MotrNotifier"]
}

resource "aws_cloudwatch_log_metric_filter" "MotrNotifierOneDayAfterReminderSuccess_log_metric_filter" {
  name           = "MotrNotifierOneDayAfterReminderSuccess_log_metric_filter"
  pattern        = "{ $.message = ONE-DAY-AFTER-EMAIL-SUCCESS }"
  log_group_name = "/aws/lambda/${aws_lambda_function.MotrNotifier.function_name}"

  metric_transformation {
    name      = "${var.project}-${var.environment}-MotrNotifier-OneDayAfterReminderSuccess"
    namespace = "${var.project}-${var.environment}-MotrNotifier-OneDayAfterReminderSuccess"
    value     = "1"
  }

  depends_on = ["aws_cloudwatch_log_group.MotrNotifier"]
}

resource "aws_cloudwatch_log_metric_filter" "MotrNotifier_MiscError_log_metric_filter" {
  name           = "MotrNotifier_MiscError_log_metric_filter"
  pattern        = "{ $.level = ERROR }"
  log_group_name = "/aws/lambda/${aws_lambda_function.MotrNotifier.function_name}"

  metric_transformation {
    name      = "${var.project}-${var.environment}-MotrNotifier-MiscError"
    namespace = "${var.project}-${var.environment}-MotrNotifier-MiscError"
    value     = "1"
  }

  depends_on = ["aws_cloudwatch_log_group.MotrNotifier"]
}
