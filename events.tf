resource "aws_cloudwatch_event_target" "MOTRWebHandler-WarmUpEventTarget" {
  count     = "${var.enable_warmup ? 1 : 0}"
  target_id = "MOTRWebHandler-WarmUpEventTarget"
  rule      = "${aws_cloudwatch_event_rule.MOTR-WarmUpEventRule.name}"
  arn       = "${aws_lambda_function.MotrWebHandler.arn}"
}

resource "aws_cloudwatch_event_rule" "MOTR-WarmUpEventRule" {
  count               = "${var.enable_warmup ? 1 : 0}"
  name                = "MOTR-WarmUpEventRule"
  description         = "MOTR WarmUp event rule"
  schedule_expression = "rate(1 minutes)"
  is_enabled          = "true"
}
