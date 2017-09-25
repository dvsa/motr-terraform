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

resource "aws_cloudwatch_log_metric_filter" "MotrBouncingEmailCleanerTemporaryFailures_log_metric_filter" {
  name           = "MotrBouncingEmailCleanerTemporaryFailures_log_metric_filter"
  pattern        = "{ $.message = STATUS-REPORT }"
  log_group_name = "/aws/lambda/${aws_lambda_function.MotrBouncingEmailCleaner.function_name}"

  metric_transformation {
    name      = "${var.project}-${var.environment}-MotrBouncingEmailCleaner-TemporaryFailures"
    namespace = "${var.project}-${var.environment}-MotrBouncingEmailCleaner"
    value     = "$.mdc.x-temporary-failure"
  }

  depends_on = ["aws_cloudwatch_log_group.MotrBouncingEmailCleaner"]
}

resource "aws_cloudwatch_log_metric_filter" "MotrBouncingEmailCleanerTechnicalFailures_log_metric_filter" {
  name           = "MotrBouncingEmailCleanerTechnicalFailures_log_metric_filter"
  pattern        = "{ $.message = STATUS-REPORT }"
  log_group_name = "/aws/lambda/${aws_lambda_function.MotrBouncingEmailCleaner.function_name}"

  metric_transformation {
    name      = "${var.project}-${var.environment}-MotrBouncingEmailCleaner-TechnicalFailures"
    namespace = "${var.project}-${var.environment}-MotrBouncingEmailCleaner"
    value     = "$.mdc.x-technical-failure"
  }

  depends_on = ["aws_cloudwatch_log_group.MotrBouncingEmailCleaner"]
}

resource "aws_cloudwatch_log_metric_filter" "MotrBouncingEmailCleanerPermanentFailures_log_metric_filter" {
  name           = "MotrBouncingEmailCleanerPermanentFailures_log_metric_filter"
  pattern        = "{ $.message = STATUS-REPORT }"
  log_group_name = "/aws/lambda/${aws_lambda_function.MotrBouncingEmailCleaner.function_name}"

  metric_transformation {
    name      = "${var.project}-${var.environment}-MotrBouncingEmailCleaner-PermanentFailures"
    namespace = "${var.project}-${var.environment}-MotrBouncingEmailCleaner"
    value     = "$.mdc.x-permanently-failed"
  }

  depends_on = ["aws_cloudwatch_log_group.MotrBouncingEmailCleaner"]
}

resource "aws_cloudwatch_log_metric_filter" "MotrBouncingEmailCleanerSmsTemporaryFailures" {
  name           = "MotrBouncingEmailCleanerSmsTemporaryFailures"
  pattern        = "{ $.message = STATUS-REPORT }"
  log_group_name = "/aws/lambda/${aws_lambda_function.MotrBouncingEmailCleaner.function_name}"

  metric_transformation {
    name      = "${var.project}-${var.environment}-MotrBouncingEmailCleaner-Sms-TemporaryFailures"
    namespace = "${var.project}-${var.environment}-MotrBouncingEmailCleaner"
    value     = "$.mdc.x-sms-temporary-failure"
  }

  depends_on = ["aws_cloudwatch_log_group.MotrBouncingEmailCleaner"]
}

resource "aws_cloudwatch_log_metric_filter" "MotrBouncingEmailCleanerSmsTechnicalFailures" {
  name           = "MotrBouncingEmailCleanerSmsTechnicalFailures"
  pattern        = "{ $.message = STATUS-REPORT }"
  log_group_name = "/aws/lambda/${aws_lambda_function.MotrBouncingEmailCleaner.function_name}"

  metric_transformation {
    name      = "${var.project}-${var.environment}-MotrBouncingEmailCleaner-Sms-TechnicalFailures"
    namespace = "${var.project}-${var.environment}-MotrBouncingEmailCleaner"
    value     = "$.mdc.x-sms-technical-failure"
  }

  depends_on = ["aws_cloudwatch_log_group.MotrBouncingEmailCleaner"]
}

resource "aws_cloudwatch_log_metric_filter" "MotrBouncingEmailCleanerSmsPermanentFailures" {
  name           = "MotrBouncingEmailCleanerSmsPermanentFailures"
  pattern        = "{ $.message = STATUS-REPORT }"
  log_group_name = "/aws/lambda/${aws_lambda_function.MotrBouncingEmailCleaner.function_name}"

  metric_transformation {
    name      = "${var.project}-${var.environment}-MotrBouncingEmailCleaner-Sms-PermanentFailures"
    namespace = "${var.project}-${var.environment}-MotrBouncingEmailCleaner"
    value     = "$.mdc.x-sms-permanently-failed"
  }

  depends_on = ["aws_cloudwatch_log_group.MotrBouncingEmailCleaner"]
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
