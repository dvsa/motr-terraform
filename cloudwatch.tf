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

resource "aws_cloudwatch_event_target" "MOTRWebHandler-WarmUpEventTarget" {
  target_id = "MOTRWebHandler-WarmUpEventTarget"
  rule      = "${aws_cloudwatch_event_rule.MOTR-WarmUpEventRule.name}"
  arn       = "${aws_lambda_alias.MotrWebHandlerAlias.arn}"
  input     = "{ \"ping\": true }"
}

resource "aws_cloudwatch_event_rule" "MOTR-WarmUpEventRule" {
  name                = "MOTR-${var.environment}-WarmUpEventRule"
  description         = "MOTR WebHandler WarmUp (${var.environment}) event rule | Schedule: ${var.web_warmup_rate}"
  schedule_expression = "${var.web_warmup_rate}"
  is_enabled          = "${var.web_enable_warmup ? 1 : 0}"
}

########## Custom Metrics ##########

resource "aws_cloudwatch_log_metric_filter" "MotrWebHandler_coldstart_log_metric_filter" {
  name           = "MotrWebHandler_coldstart_log_metric_filter"
  pattern        = "{ $.mdc.x-cold-start = true && $.message = PING }"
  log_group_name = "${var.manage_cw_lg_web_lambda ? "${aws_cloudwatch_log_group.MotrWebHandler.name}" : "/aws/lambda/${aws_lambda_function.MotrWebHandler.function_name}"}"
  metric_transformation {
    name      = "${var.project}-${var.environment}-MotrWebHandler-ColdStart"
    namespace = "${var.project}-${var.environment}-MotrWebHandler-ColdStart"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "MOTRNotifyConfFailure_log_metric_filter" {
  name           = "MOTRNotifyConfFailure_log_metric_filter"
  pattern        = "{ $.message = NOTIFY-CONFIRMATION-FAILURE || $.message = NOTIFY-CLIENT-FAILED }"
  log_group_name = "${var.manage_cw_lg_web_lambda ? "${aws_cloudwatch_log_group.MotrWebHandler.name}" : "/aws/lambda/${aws_lambda_function.MotrWebHandler.function_name}"}"
  metric_transformation {
    name      = "${var.project}-${var.environment}-NotifyConfirmationFailure"
    namespace = "${var.project}-${var.environment}-NotifyConfirmationFailure"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "MOTRNotifyReminderFailure_log_metric_filter" {
  name           = "MOTRNotifyReminderFailure_log_metric_filter"
  pattern        = "{ $.message = NOTIFY-REMINDER-FAILED }"
  log_group_name = "${var.manage_cw_lg_web_lambda ? "${aws_cloudwatch_log_group.MotrNotifier.name}" : "/aws/lambda/${aws_lambda_function.MotrNotifier.function_name}"}"
  metric_transformation {
    name      = "${var.project}-${var.environment}-NotifyReminderFailure"
    namespace = "${var.project}-${var.environment}-NotifyReminderFailure"
    value     = "1"
  }
}


resource "aws_cloudwatch_log_metric_filter" "MOTRSubscriptionActivationFailure_log_metric_filter" {
  name           = "MOTRSubscriptionActivationFailure_log_metric_filter"
  pattern        = "{ $.message = SUBSCRIPTION-ACTIVATION-FAILED }"
  log_group_name = "${var.manage_cw_lg_web_lambda ? "${aws_cloudwatch_log_group.MotrWebHandler.name}" : "/aws/lambda/${aws_lambda_function.MotrWebHandler.function_name}"}"
  metric_transformation {
    name      = "${var.project}-${var.environment}-SubscriptionActivationFailure"
    namespace = "${var.project}-${var.environment}-SubscriptionActivationFailure"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "MOTRPendingSubscriptionFailure_log_metric_filter" {
  name           = "MOTRPendingSubscriptionFailure_log_metric_filter"
  pattern        = "{ $.message = PENDING-SUBSCRIPTION-CREATION-FAILED }"
  log_group_name = "${var.manage_cw_lg_web_lambda ? "${aws_cloudwatch_log_group.MotrWebHandler.name}" : "/aws/lambda/${aws_lambda_function.MotrWebHandler.function_name}"}"
  metric_transformation {
    name      = "${var.project}-${var.environment}-PendingSubscriptionFailure"
    namespace = "${var.project}-${var.environment}-PendingSubscriptionFailure"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "MOTRTradeAPIFailure_log_metric_filter" {
  name           = "MOTRTradeAPIFailure_log_metric_filter"
  pattern        = "{ $.message = TRADE-API-ERROR }"
  log_group_name = "${var.manage_cw_lg_web_lambda ? "${aws_cloudwatch_log_group.MotrWebHandler.name}" : "/aws/lambda/${aws_lambda_function.MotrWebHandler.function_name}"}"
  metric_transformation {
    name      = "${var.project}-${var.environment}-TradeAPIFailure"
    namespace = "${var.project}-${var.environment}-TradeAPIFailure"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "MotrWebHandler_MiscError_log_metric_filter" {
  name           = "MotrWebHandler_MiscError_log_metric_filter"
  pattern        = "{ $.level = ERROR && $.message != NOTIFY-CONFIRMATION-FAILURE && $.message != NOTIFY-CLIENT-FAILED && $.message != TRADE-API-ERROR && $.message != SUBSCRIPTION-ACTIVATION-FAILED && $.message != PENDING-SUBSCRIPTION-CREATION-FAILED }"
  log_group_name = "${var.manage_cw_lg_web_lambda ? "${aws_cloudwatch_log_group.MotrWebHandler.name}" : "/aws/lambda/${aws_lambda_function.MotrWebHandler.function_name}"}"
  metric_transformation {
    name      = "${var.project}-${var.environment}-MiscError"
    namespace = "${var.project}-${var.environment}-MiscError"
    value     = "1"
  }
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
  arn       = "${aws_lambda_function.MotrSubscriptionLoader.arn}"
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
  arn       = "${aws_lambda_function.MotrNotifier.arn}"
}
