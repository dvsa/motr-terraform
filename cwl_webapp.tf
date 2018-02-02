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

####################################################################################################################################
# METRICS

resource "aws_cloudwatch_log_metric_filter" "MotrWebHandler_coldstart_log_metric_filter" {
  name           = "MotrWebHandler_coldstart_log_metric_filter"
  pattern        = "{ $.mdc.x-cold-start = true && $.message = PING }"
  log_group_name = "/aws/lambda/${aws_lambda_function.MotrWebHandler.function_name}"

  metric_transformation {
    name      = "${var.project}-${var.environment}-MotrWebHandler-ColdStart"
    namespace = "${var.project}-${var.environment}-MotrWebHandler"
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
    namespace = "${var.project}-${var.environment}-MotrWebHandler"
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
    namespace = "${var.project}-${var.environment}-MotrWebHandler"
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
    namespace = "${var.project}-${var.environment}-MotrWebHandler"
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
    namespace = "${var.project}-${var.environment}-MotrWebHandler"
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
    namespace = "${var.project}-${var.environment}-MotrWebHandler"
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
    namespace = "${var.project}-${var.environment}-MotrWebHandler"
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
    namespace = "${var.project}-${var.environment}-MotrWebHandler"
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
    namespace = "${var.project}-${var.environment}-MotrWebHandler"
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
    namespace = "${var.project}-${var.environment}-MotrWebHandler"
    value     = "1"
  }

  depends_on = ["aws_cloudwatch_log_group.MotrWebHandler"]
}

####################################################################################################################################
# ALARMS
resource "aws_cloudwatch_metric_alarm" "MotrWebHandlerNotifyConfFailure_alarm" {
  alarm_name          = "${var.project}-${var.environment}-MotrWebHandlerNotifyConfFailureAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "${var.project}-${var.environment}-MotrWebHandler-NotifyConfirmationFailure"
  namespace           = "${var.project}-${var.environment}-MotrWebHandler"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"

  alarm_description = "Error submitting SMS or email to GOV Notify"
  alarm_actions     = ["${aws_sns_topic.MotrOpsGenieAlarm_sns_topic.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "MotrWebHandlerTradeAPIFailure_alarm" {
  alarm_name          = "${var.project}-${var.environment}-MotrWebHandlerTradeAPIFailureAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "${var.project}-${var.environment}-MotrWebHandler-TradeAPIFailure"
  namespace           = "${var.project}-${var.environment}-MotrWebHandler"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"

  alarm_description = "Error communicating with Trade API"
  alarm_actions     = ["${aws_sns_topic.MotrOpsGenieAlarm_sns_topic.arn}"]
}
