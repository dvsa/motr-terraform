## KMS key for enabling encryption for environment variables

data "template_file" "kms_lambda_policy" {
  template       = "${file("${path.module}/iam_policies/kms_key_policy.json.tpl")}"
  vars {
    aws_region                            = "${var.aws_region}"
    MotrWebAppLambda_role_arn             = "${aws_iam_role.MotrWebAppLambda.arn}"
    MotrSubscriptionLoaderLambda_role_arn = "${aws_iam_role.MotrSubscriptionLoaderLambda.arn}"
    MotrNotifierLambda_role_arn           = "${aws_iam_role.MotrNotifierLambda.arn}"
    account_id                            = "${data.aws_caller_identity.current.account_id}"
  }
}

resource "aws_kms_key" "MOTR_Lambda_Key" {
  description             = "motr-${var.environment}"
  enable_key_rotation     = "${var.kms_key_rotation ? true : false}"
  deletion_window_in_days = "${var.kms_deletion_window}"
  policy                  = "${data.template_file.kms_lambda_policy.rendered}"
  depends_on              = ["aws_iam_role.MotrWebAppLambda"
                             , "aws_iam_role.MotrSubscriptionLoaderLambda"
                             , "aws_iam_role.MotrNotifierLambda"]
}

resource "aws_kms_alias" "MOTR_Lambda_Alias" {
  name          = "alias/motr-${var.environment}"
  target_key_id = "${aws_kms_key.MOTR_Lambda_Key.key_id}"
}
