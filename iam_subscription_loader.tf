resource "aws_iam_role" "MotrSubscriptionLoaderLambda" {
  name               = "motr-subscr-loader-lambda-${var.environment}"
  assume_role_policy = "${data.template_file.lambda_assumerole_policy.rendered}"
}

data "template_file" "lambda_subscr_loader_permissions_policy" {
  template = "${file("${path.module}/iam_policies/lambda_subscr_loader_permissions_policy.json.tpl")}"

  vars {
    aws_region      = "${var.aws_region}"
    environment     = "${var.environment}"
    account_id      = "${data.aws_caller_identity.current.account_id}"
    lambda_function = "${aws_lambda_function.MotrSubscriptionLoader.function_name}"
    queue_name      = "${aws_sqs_queue.MotrSubscriptionsQueue.name}"
  }
}

resource "aws_iam_role_policy" "MotrSubscriptionLoaderLambda" {
  name   = "motr-subscr-loader-policy-${var.environment}"
  role   = "${aws_iam_role.MotrSubscriptionLoaderLambda.id}"
  policy = "${data.template_file.lambda_subscr_loader_permissions_policy.rendered}"
}
