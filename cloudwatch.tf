####################################################################################################################################
# WEBAPP

resource "aws_cloudwatch_log_group" "MotrWebHandler" {
  count             = "${var.manage_cw_lg_web_lambda ? 1 : 0}"
  name              = "/aws/lambda/${aws_lambda_function.MotrWebHandler.function_name}"
  retention_in_days = "${var.cw_lg_web_lambda_retention}"

  tags {
    Name        = "${var.project}-${var.environment}-MotrWebHandler"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}

resource "aws_cloudwatch_log_metric_filter" "MotrWebHandler_coldstart_log_metric_filter" {
  name           = "MotrWebHandler_coldstart_log_metric_filter"
  pattern        = "{ $.mdc.x-cold-start = true && $.message = PING }"
  log_group_name = "/aws/lambda/${aws_lambda_function.MotrWebHandler.function_name}"

  metric_transformation {
    name      = "${var.project}-${var.environment}-MotrWebHandler-ColdStart"
    namespace = "${var.project}-${var.environment}-MotrWebHandler-ColdStart"
    value     = "1"
  }

  depends_on = ["aws_cloudwatch_log_group.MotrWebHandler"]
}

resource "aws_cloudwatch_log_metric_filter" "MotrWebHandlerNotifyConfFailure_log_metric_filter" {
  name           = "MotrWebHandlerNotifyConfFailure_log_metric_filter"
  pattern        = "{ $.message = NOTIFY-CLIENT-FAILED }"
  log_group_name = "/aws/lambda/${aws_lambda_function.MotrWebHandler.function_name}"

  metric_transformation {
    name      = "${var.project}-${var.environment}-MotrWebHandler-NotifyConfirmationFailure"
    namespace = "${var.project}-${var.environment}-MotrWebHandler-NotifyConfirmationFailure"
    value     = "1"
  }

  depends_on = ["aws_cloudwatch_log_group.MotrWebHandler"]
}

resource "aws_cloudwatch_log_metric_filter" "MotrWebHandlerColdStartUserExperience_log_metric_filter" {
  name           = "MotrWebHandlerColdStartUserExperience_log_metric_filter"
  pattern        = "{ $.mdc.x-cold-start = true && $.message = ACCESS }"
  log_group_name = "/aws/lambda/${aws_lambda_function.MotrWebHandler.function_name}"

  metric_transformation {
    name      = "${var.project}-${var.environment}-MotrWebHandler-ColdStartUserExperience"
    namespace = "${var.project}-${var.environment}-MotrWebHandler-ColdStartUserExperience"
    value     = "1"
  }

  depends_on = ["aws_cloudwatch_log_group.MotrWebHandler"]
}

resource "aws_cloudwatch_log_metric_filter" "MotrWebHandlerSubscriptionActivationFailure_log_metric_filter" {
  name           = "MotrWebHandlerSubscriptionActivationFailure_log_metric_filter"
  pattern        = "{ $.message = SUBSCRIPTION-CONFIRMATION-FAILED }"
  log_group_name = "/aws/lambda/${aws_lambda_function.MotrWebHandler.function_name}"

  metric_transformation {
    name      = "${var.project}-${var.environment}-MotrWebHandler-SubscriptionActivationFailure"
    namespace = "${var.project}-${var.environment}-MotrWebHandler-SubscriptionActivationFailure"
    value     = "1"
  }

  depends_on = ["aws_cloudwatch_log_group.MotrWebHandler"]
}

resource "aws_cloudwatch_log_metric_filter" "MotrWebHandlerPendingSubscriptionFailure_log_metric_filter" {
  name           = "MotrWebHandlerPendingSubscriptionFailure_log_metric_filter"
  pattern        = "{ $.message = PENDING-SUBSCRIPTION-CREATION-FAILED }"
  log_group_name = "/aws/lambda/${aws_lambda_function.MotrWebHandler.function_name}"

  metric_transformation {
    name      = "${var.project}-${var.environment}-MotrWebHandler-PendingSubscriptionFailure"
    namespace = "${var.project}-${var.environment}-MotrWebHandler-PendingSubscriptionFailure"
    value     = "1"
  }

  depends_on = ["aws_cloudwatch_log_group.MotrWebHandler"]
}

resource "aws_cloudwatch_log_metric_filter" "MotrWebHandlerTradeAPIFailure_log_metric_filter" {
  name           = "MotrWebHandlerTradeAPIFailure_log_metric_filter"
  pattern        = "{ $.message = TRADE-API-ERROR }"
  log_group_name = "/aws/lambda/${aws_lambda_function.MotrWebHandler.function_name}"

  metric_transformation {
    name      = "${var.project}-${var.environment}-MotrWebHandler-TradeAPIFailure"
    namespace = "${var.project}-${var.environment}-MotrWebHandler-TradeAPIFailure"
    value     = "1"
  }

  depends_on = ["aws_cloudwatch_log_group.MotrWebHandler"]
}

resource "aws_cloudwatch_log_metric_filter" "MotrWebHandlerPendingSubscriptionCreated_log_metric_filter" {
  name           = "MotrWebHandlerPendingSubscriptionCreated_log_metric_filter"
  pattern        = "{ $.message = PENDING-SUBSCRIPTION-CREATED }"
  log_group_name = "/aws/lambda/${aws_lambda_function.MotrWebHandler.function_name}"

  metric_transformation {
    name      = "${var.project}-${var.environment}-MotrWebHandler-PendingSubscriptionCreated"
    namespace = "${var.project}-${var.environment}-MotrWebHandler-PendingSubscriptionCreated"
    value     = "1"
  }

  depends_on = ["aws_cloudwatch_log_group.MotrWebHandler"]
}

resource "aws_cloudwatch_log_metric_filter" "MotrWebHandlerSubscriptionConfirmed_log_metric_filter" {
  name           = "MotrWebHandlerSubscriptionConfirmed_log_metric_filter"
  pattern        = "{ $.message = SUBSCRIPTION-CONFIRMED }"
  log_group_name = "/aws/lambda/${aws_lambda_function.MotrWebHandler.function_name}"

  metric_transformation {
    name      = "${var.project}-${var.environment}-MotrWebHandler-SubscriptionConfirmed"
    namespace = "${var.project}-${var.environment}-MotrWebHandler-SubscriptionConfirmed"
    value     = "1"
  }

  depends_on = ["aws_cloudwatch_log_group.MotrWebHandler"]
}

resource "aws_cloudwatch_log_metric_filter" "MotrWebHandlerSessionMalformedError_log_metric_filter" {
  name           = "MotrWebHandlerSessionMalformedError_log_metric_filter"
  pattern        = "{ $.message = SESSION-MALFORMED-ERROR }"
  log_group_name = "/aws/lambda/${aws_lambda_function.MotrWebHandler.function_name}"

  metric_transformation {
    name      = "${var.project}-${var.environment}-MotrWebHandler-SessionMalformedError"
    namespace = "${var.project}-${var.environment}-MotrWebHandler-SessionMalformedError"
    value     = "1"
  }

  depends_on = ["aws_cloudwatch_log_group.MotrWebHandler"]
}

resource "aws_cloudwatch_log_metric_filter" "MotrWebHandler_MiscError_log_metric_filter" {
  name           = "MotrWebHandler_MiscError_log_metric_filter"
  pattern        = "{ $.level = ERROR }"
  log_group_name = "/aws/lambda/${aws_lambda_function.MotrWebHandler.function_name}"

  metric_transformation {
    name      = "${var.project}-${var.environment}-MotrWebHandler-MiscError"
    namespace = "${var.project}-${var.environment}-MotrWebHandler-MiscError"
    value     = "1"
  }

  depends_on = ["aws_cloudwatch_log_group.MotrWebHandler"]
}

####################################################################################################################################
# SUBSCRIPTION LOADER

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

####################################################################################################################################
# NOTIFIER

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

####################################################################################################################################
# NPINGER

resource "aws_cloudwatch_log_group" "NPinger" {
  count             = "${var.manage_cw_lg_npinger_lambda ? 1 : 0}"
  name              = "/aws/lambda/${aws_lambda_function.NPinger.function_name}"
  retention_in_days = "${var.cw_lg_npinger_lambda_retention}"

  tags {
    Name        = "${var.project}-${var.environment}-NPinger"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}

resource "aws_cloudwatch_event_rule" "MOTR-WarmUpEventRule" {
  name                = "MOTR-${var.environment}-WarmUpEventRule"
  description         = "MOTR WebHandler WarmUp (${var.environment}) event rule | Schedule: ${var.web_warmup_rate}"
  schedule_expression = "${var.web_warmup_rate}"
  is_enabled          = "${var.web_enable_warmup ? 1 : 0}"
}

resource "aws_cloudwatch_event_target" "MOTRWebHandler-WarmUpEventTarget" {
  target_id = "MOTRWebHandler-WarmUpEventTarget"
  rule      = "${aws_cloudwatch_event_rule.MOTR-WarmUpEventRule.name}"
  arn       = "${aws_lambda_alias.NPingerAlias.arn}"
}

###################################################################################################################################
resource "aws_cloudwatch_log_group" "MotrBouncingEmailCleaner" {
  count             = "${var.manage_cw_lg_cleaner_lambda ? 1 : 0}"
  name              = "/aws/lambda/${aws_lambda_function.MotrBouncingEmailCleaner.function_name}"
  retention_in_days = "${var.cw_lg_cleaner_lambda_retention}"

  tags {
    Name        = "${var.project}-${var.environment}-MotrBouncingEmailCleaner"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}

resource "aws_cloudwatch_event_rule" "MotrBouncingEmailCleanerStart" {
  name                = "motr-cleaner-start-${var.environment}"
  description         = "MOTR MotrBouncingEmailCleanerStart Start (${var.environment}) event rule | Schedule: ${var.motr_cleaner_schedule}"
  is_enabled          = "${var.motr_cleaner_enabled}"
  schedule_expression = "${var.motr_cleaner_schedule}"
}

resource "aws_cloudwatch_event_target" "MotrBouncingEmailCleanerStart" {
  rule      = "${aws_cloudwatch_event_rule.MotrBouncingEmailCleanerStart.name}"
  target_id = "${aws_cloudwatch_event_rule.MotrBouncingEmailCleanerStart.name}-target"
  arn       = "${aws_lambda_alias.MotrBouncingEmailCleaner.arn}"
}
