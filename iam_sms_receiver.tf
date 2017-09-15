resource "aws_iam_role" "MotrSmsReceiverLambda" {
  name               = "motr-sms-receiver-lambda-${var.environment}"
  assume_role_policy = "${data.template_file.lambda_assumerole_policy.rendered}"
}

data "template_file" "lambda_sms_receiver_permissions_policy" {
  template = "${file("${path.module}/iam_policies/lambda_cleaner_permissions_policy.json.tpl")}"

  vars {
    aws_region      = "${var.aws_region}"
    environment     = "${var.environment}"
    account_id      = "${data.aws_caller_identity.current.account_id}"
    lambda_function = "${aws_lambda_function.MotrSmsReceiver.function_name}"
  }
}

resource "aws_iam_role_policy" "MotrSmsReceiverLambda" {
  name   = "motr-subscr-loader-policy-${var.environment}"
  role   = "${aws_iam_role.MotrSmsReceiverLambda.id}"
  policy = "${data.template_file.lambda_sms_receiver_permissions_policy.rendered}"
}
