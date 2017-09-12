data "template_file" "lambda_assumerole_policy" {
  template = "${file("${path.module}/iam_policies/lambda_assumerole_policy.json.tpl")}"
}

resource "aws_iam_role" "MotrWebAppLambda" {
  name               = "motr-lambda-${var.environment}"
  assume_role_policy = "${data.template_file.lambda_assumerole_policy.rendered}"
}

data "template_file" "lambda_webapp_permissions_policy" {
  template = "${file("${path.module}/iam_policies/lambda_webapp_permissions_policy.json.tpl")}"

  vars {
    aws_region      = "${var.aws_region}"
    environment     = "${var.environment}"
    account_id      = "${data.aws_caller_identity.current.account_id}"
    lambda_function = "${aws_lambda_function.MotrWebHandler.function_name}"
  }
}

resource "aws_iam_role_policy" "MotrWebAppLambda" {
  name   = "motr-web-policy-${var.environment}"
  role   = "${aws_iam_role.MotrWebAppLambda.id}"
  policy = "${data.template_file.lambda_webapp_permissions_policy.rendered}"
}
