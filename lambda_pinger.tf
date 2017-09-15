resource "aws_lambda_function" "NPinger" {
  description   = "MotrNPinger"
  runtime       = "nodejs4.3"
  filename      = "lambda_warmer/${var.NPinger_lambda_filename}"
  function_name = "MotrNPinger-${var.environment}"
  role          = "${aws_iam_role.NPingerRole.arn}"
  handler       = "npinger.warmup"
  publish       = "${var.NPinger_publish}"
  memory_size   = "${var.NPinger_mem_size}"
  timeout       = "${var.NPinger_timeout}"

  environment {
    variables = {
      REGION                  = "${var.aws_region}"
      FUNCTION_NAME           = "${aws_lambda_function.MotrWebHandler.function_name}"
      CONCURRENT_TARGET_COUNT = "${var.NPinger_concurrent_target_count}"
      PAYLOAD                 = "${var.NPinger_payload}"
    }
  }
}

resource "aws_lambda_alias" "NPingerAlias" {
  name             = "${var.environment}"
  description      = "Alias for ${aws_lambda_function.NPinger.function_name}"
  function_name    = "${aws_lambda_function.NPinger.arn}"
  function_version = "${var.NPinger_ver}"
}

resource "aws_lambda_permission" "Allow_CloudWatchEvent" {
  function_name = "${aws_lambda_function.NPinger.function_name}"
  qualifier     = "${aws_lambda_alias.NPingerAlias.name}"
  statement_id  = "AllowExecutionFromCloudWatchEvent"
  action        = "lambda:InvokeFunction"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.MOTR-WarmUpEventRule.arn}"
}
