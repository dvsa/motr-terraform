####################################################################################################################################
# IAM

# Loader
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

# Notifier
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
# DYNAMO DB

resource "aws_dynamodb_table" "motr-subscription" {
  name           = "motr-${var.environment}-subscription"
  read_capacity  = "${var.tb_subscr_read_capacity}"
  write_capacity = "${var.tb_subscr_write_capacity}"
  hash_key       = "email"
  range_key      = "vrm"
  attribute {
    name = "id"
    type = "S"
  }
  attribute {
    name = "email"
    type = "S"
  }
  attribute {
    name = "vrm"
    type = "S"
  }
  attribute {
    name = "mot_due_date_md"
    type = "S"
  }
  global_secondary_index {
    name               = "due-date-md-gsi"
    hash_key           = "mot_due_date_md"
    read_capacity      = "${var.ix_subscr_ddg_read_capacity}"
    write_capacity     = "${var.ix_subscr_ddg_write_capacity}"
    projection_type    = "INCLUDE"
    non_key_attributes = [ "id" ]
  }
  global_secondary_index {
    name               = "id-gsi"
    hash_key           = "id"
    read_capacity      = "${var.ix_subscr_ig_read_capacity}"
    write_capacity     = "${var.ix_subscr_ig_write_capacity}"
    projection_type    = "INCLUDE"
    non_key_attributes = [ "mot_due_date" ]
  }
}

resource "aws_dynamodb_table" "motr-pending_subscription" {
  name           = "motr-${var.environment}-pending_subscription"
  read_capacity  = "${var.tb_pending_subscr_read_capacity}"
  write_capacity = "${var.tb_pending_subscr_write_capacity}"
  hash_key       = "email"
  range_key      = "vrm"
  attribute {
    name = "id"
    type = "S"
  }
  attribute {
    name = "email"
    type = "S"
  }
  attribute {
    name = "vrm"
    type = "S"
  }
  global_secondary_index {
    name               = "id-gsi"
    hash_key           = "id"
    write_capacity     = "${var.ix_pending_subscr_ig_read_capacity}"
    read_capacity      = "${var.ix_pending_subscr_ig_write_capacity}"
    projection_type    = "INCLUDE"
    non_key_attributes = [ "mot_due_date" ]
  }
}

####################################################################################################################################
# BACKEND LAMBDAS

# Loader
resource "aws_lambda_function" "MotrSubscriptionLoader" {
  description   = "MotrSubscriptionLoader"
  runtime       = "java8"
  s3_bucket     = "${aws_s3_bucket.MOTRS3Bucket.bucket}"
  s3_key        = "lambdas/${var.MotrSubscriptionLoader_s3_key}"
  function_name = "MotrSubscriptionLoader-${var.environment}"
  role          = "${aws_iam_role.MotrSubscriptionLoaderLambda.arn}"
  handler       = "uk.gov.dvsa.motr.subscriptionloader.handler.EventHandler::handle"
  publish       = "${var.MotrSubscriptionLoader_publish}"
  memory_size   = "${var.MotrSubscriptionLoader_mem_size}"
  timeout       = "${var.MotrSubscriptionLoader_timeout}"
  kms_key_arn   = "${aws_kms_key.MOTR_Lambda_Key.arn}"
  environment {
    variables = {
      LOG_LEVEL               = "${var.subscr_loader_log_level}"
      REGION                  = "${var.aws_region}"
      DB_TABLE_SUBSCRIPTION   = "motr-${var.environment}-subscription"
      SUBSCRIPTIONS_QUEUE_URL = "${aws_sqs_queue.MotrSubscriptionsQueue.id}"
    }
  }
}

resource "aws_lambda_alias" "MotrSubscriptionLoader" {
  name             = "${var.environment}"
  description      = "Alias for ${aws_lambda_function.MotrSubscriptionLoader.function_name}"
  function_name    = "${aws_lambda_function.MotrSubscriptionLoader.arn}"
  function_version = "${var.MotrSubscriptionLoader_ver}"
}

# Notifier
resource "aws_lambda_function" "MotrNotifier" {
  description   = "MotrNotifier"
  runtime       = "java8"
  s3_bucket     = "${aws_s3_bucket.MOTRS3Bucket.bucket}"
  s3_key        = "lambdas/${var.MotrNotifier_s3_key}"
  function_name = "MotrNotifier-${var.environment}"
  role          = "${aws_iam_role.MotrNotifierLambda.arn}"
  handler       = "uk.gov.dvsa.motr.notifier.handler.EventHandler::handle"
  publish       = "${var.MotrNotifier_publish}"
  memory_size   = "${var.MotrNotifier_mem_size}"
  timeout       = "${var.MotrNotifier_timeout}"
  kms_key_arn   = "${aws_kms_key.MOTR_Lambda_Key.arn}"
  environment {
    variables = {
      LOG_LEVEL               = "${var.notifier_log_level}"
      REGION                  = "${var.aws_region}"
      DB_TABLE_SUBSCRIPTION   = "motr-${var.environment}-subscription"
      SUBSCRIPTIONS_QUEUE_URL = "${aws_sqs_queue.MotrSubscriptionsQueue.id}"
    }
  }
}

resource "aws_lambda_alias" "MotrNotifier" {
  name             = "${var.environment}"
  description      = "Alias for ${aws_lambda_function.MotrNotifier.function_name}"
  function_name    = "${aws_lambda_function.MotrNotifier.arn}"
  function_version = "${var.MotrNotifier_ver}"
}

####################################################################################################################################
# CLOUDWATCH EVENTS

# Loader
resource "aws_cloudwatch_event_rule" "MotrLoaderStart" {
  name                = "motr-loader-start-${var.environment}"
  description         = "MOTR Loader Start (${var.environment}) event rule | Schedule: ${var.motr_loader_schedule}"
  is_enabled          = "${var.motr_loader_enabled}"
  schedule_expression = "${var.motr_loader_schedule}"
}

resource "aws_cloudwatch_event_target" "MotrLoaderStart" {
  rule      = "${aws_cloudwatch_event_rule.MotrLoaderStart.name}"
  target_id = "${aws_cloudwatch_event_rule.MotrLoaderStart.name}-target"
  arn       = "${aws_lambda_function.MotrSubscriptionLoader.arn}"
}

# Notifier
resource "aws_cloudwatch_event_rule" "MotrNotifierStart" {
  name                = "motr-notifier-start-${var.environment}"
  description         = "MOTR MotrNotifierStart Start (${var.environment}) event rule | Schedule: ${var.motr_notifier_schedule}"
  is_enabled          = "${var.motr_notifier_enabled}"
  schedule_expression = "${var.motr_notifier_schedule}"
}

resource "aws_cloudwatch_event_target" "MotrNotifierStart" {
  rule      = "${aws_cloudwatch_event_rule.MotrNotifierStart.name}"
  target_id = "${aws_cloudwatch_event_rule.MotrNotifierStart.name}-target"
  arn       = "${aws_lambda_function.MotrNotifier.arn}"
}

####################################################################################################################################
# SQS

resource "aws_sqs_queue" "MotrSubscriptionsQueue" {
  name                      = "motr-subscription-queue-${var.environment}"
  delay_seconds             = "${var.motr_subscribtion_q_delay_s}"
  max_message_size          = "${var.motr_subscribtion_q_max_msg_size}"
  message_retention_seconds = "${var.motr_subscribtion_q_msg_retention_s}"
  receive_wait_time_seconds = "${var.motr_subscribtion_q_receive_wait_s}"
  #redrive_policy            = "???"
}
