####################################################################################################################################
# S3

data "aws_iam_policy_document" "s3_policy" {
  statement {
    sid     = "Grant CF OAI access to static assets on S3"
    actions = ["s3:GetObject"]

    resources = [
      "arn:aws:s3:::${var.bucket_prefix}${var.environment}/assets/*",
      "arn:aws:s3:::${var.bucket_prefix}${var.environment}/errorpages/*",
    ]

    principals {
      type        = "AWS"
      identifiers = ["${var.with_cloudfront ? "${aws_cloudfront_origin_access_identity.oai.iam_arn}" : "*"}"]
    }
  }
}

####################################################################################################################################
# API GATEWAY

# IAM role + policy that grants API Gateway permissons to assume roles
data "template_file" "apig_assumerole_policy" {
  template = "${file("${path.module}/iam_policies/apig_assumerole_policy.json.tpl")}"
}

resource "aws_iam_role" "APIGateway" {
  name               = "motr-web-${var.environment}"
  assume_role_policy = "${data.template_file.apig_assumerole_policy.rendered}"
}

####################################################################################################################################
# WEBAPP

# IAM role + policy that grants WebApp Lambda permissons to assume roles
data "template_file" "lambda_assumerole_policy" {
  template = "${file("${path.module}/iam_policies/lambda_assumerole_policy.json.tpl")}"
}

resource "aws_iam_role" "MotrWebAppLambda" {
  name               = "motr-lambda-${var.environment}"
  assume_role_policy = "${data.template_file.lambda_assumerole_policy.rendered}"
}

# IAM policy that grants WebApp Lambda required permissons
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

####################################################################################################################################
# SUBSCRIPTION LOADER

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

####################################################################################################################################
# NOTIFIER

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

####################################################################################################################################
# NPINGER

resource "aws_iam_role" "NPingerRole" {
  name               = "NPingerRole-${var.environment}"
  assume_role_policy = "${data.template_file.lambda_assumerole_policy.rendered}"
}

data "template_file" "npinger_warmer_permissions_policy" {
  template = "${file("${path.module}/iam_policies/npinger_warmer_permissions_policy.json.tpl")}"

  vars {
    aws_region              = "${var.aws_region}"
    environment             = "${var.environment}"
    account_id              = "${data.aws_caller_identity.current.account_id}"
    lambda_warming_function = "${aws_lambda_function.MotrWebHandler.function_name}"
  }
}

resource "aws_iam_role_policy" "LambdaWarmerRolePolicy" {
  name   = "LambdaWarmerRolePolicy-${var.environment}"
  role   = "${aws_iam_role.NPingerRole.id}"
  policy = "${data.template_file.npinger_warmer_permissions_policy.rendered}"
}

####################################################################################################################################
# BOUNCING EMAIL CLEANER

resource "aws_iam_role" "MotrBouncingEmailCleanerLambda" {
  name               = "motr-bouncing-email-cleaner-lambda-${var.environment}"
  assume_role_policy = "${data.template_file.lambda_assumerole_policy.rendered}"
}

data "template_file" "lambda_cleaner_permissions_policy" {
  template = "${file("${path.module}/iam_policies/lambda_cleaner_permissions_policy.json.tpl")}"

  vars {
    aws_region      = "${var.aws_region}"
    environment     = "${var.environment}"
    account_id      = "${data.aws_caller_identity.current.account_id}"
    lambda_function = "${aws_lambda_function.MotrBouncingEmailCleaner.function_name}"
  }
}

resource "aws_iam_role_policy" "MotrBouncingEmailCleanerLambda" {
  name   = "motr-subscr-loader-policy-${var.environment}"
  role   = "${aws_iam_role.MotrBouncingEmailCleanerLambda.id}"
  policy = "${data.template_file.lambda_cleaner_permissions_policy.rendered}"
}
