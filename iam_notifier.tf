resource "aws_iam_role" "MotrNotifierLambda" {
  name               = "motr-subscr-notifier-lambda-${var.environment}"
  assume_role_policy = "${data.template_file.lambda_assumerole_policy.rendered}"
}

data "template_file" "lambda_notifier_permissions_policy" {
  template = "${file("${path.module}/iam_policies/lambda_notifier_permissions_policy.json.tpl")}"

  vars {
    aws_region      = "${var.aws_region}"
    environment     = "${var.environment}"
    account_id      = "${data.aws_caller_identity.current.account_id}"
    lambda_function = "${aws_lambda_function.MotrNotifier.function_name}"
    queue_name      = "${aws_sqs_queue.MotrSubscriptionsQueue.name}"
  }
}

resource "aws_iam_role_policy" "MotrNotifierLambda" {
  name   = "motr-notifier-policy-${var.environment}"
  role   = "${aws_iam_role.MotrNotifierLambda.id}"
  policy = "${data.template_file.lambda_notifier_permissions_policy.rendered}"
}
