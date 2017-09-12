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
