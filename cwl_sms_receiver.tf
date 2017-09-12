resource "aws_cloudwatch_log_group" "MotrSmsReceiver" {
  count             = "${var.manage_cw_lg_sms_receiver_lambda ? 1 : 0}"
  name              = "/aws/lambda/${aws_lambda_function.MotrSmsReceiver.function_name}"
  retention_in_days = "${var.cw_lg_sms_receiver_lambda_retention}"

  tags {
    Name        = "${var.project}-${var.environment}-MotrSmsReceiver"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}
